<#
.SYNOPSIS
  Clean-Transcript.ps1 - Limpia transcripciones crudas de Teams para reducir ruido.

.DESCRIPTION
  Convierte el .txt crudo que deja Teams (un bloque "Local/Online speaker YYYY-MM-DD
  HH:MM:SS" + una linea de texto, por cada frase) en un .md compacto:

    1. Fusiona turnos consecutivos del mismo hablante en un solo parrafo.
    2. Descarta turnos que son PURO relleno ("si", "aja", "mhm", "ok", "claro"...).
       Un turno se descarta solo si TODAS sus palabras son relleno, asi que datos
       cortos que si importan ("71002", "712") se conservan.
    3. Vuelve a fusionar (al quitar los "aja" quedan turnos contiguos del mismo
       hablante que antes estaban separados).
    4. Colapsa frases repetidas contiguas (tartamudeo del reconocedor de voz).

  Reduccion tipica: ~726 bloques -> ~115 turnos, ~43% menos bytes. El texto que
  sobra es contenido, no cabecera.

  Es una limpieza MECANICA: no resume, no interpreta, no pierde contenido. La
  sintesis la hace el agente despues, sobre un archivo con menos ruido.

.PARAMETER Path
  Archivo .txt/.md a limpiar, o carpeta (procesa todos los .txt). Default: Input.

.PARAMETER LocalName
  Nombre para "Local speaker": quien GRABO la junta, no necesariamente el dueno del
  vault. Default: 'Local'.

.PARAMETER OnlineName
  Nombre para "Online speaker": TODOS los remotos juntos. Default: 'Remotos'.

.PARAMETER MaxMergeMinutes
  Corta el parrafo cuando el mismo hablante lleva mas de N minutos hablando, para no
  perder los timestamps intermedios de un monologo largo. Default: 2. Usa 0 para
  fusionar sin limite.

.PARAMETER KeepFillers
  Conserva los turnos de relleno (solo fusiona y quita cabeceras).

.PARAMETER Force
  Sobreescribe el .md de salida si ya existe.

.EXAMPLE
  powershell -File scripts\Clean-Transcript.ps1
  powershell -File scripts\Clean-Transcript.ps1 -Path "Input\Destino y entrega.txt"
  powershell -File scripts\Clean-Transcript.ps1 -LocalName Bruno -OnlineName "Chris/Michael" -Force

.NOTES
  Compatible con PowerShell 5.1+ y PowerShell 7+.
  ponytail: "Online speaker" agrupa a TODOS los remotos - Teams no los separa en el
  .txt. Si algun dia hace falta distinguirlos, se hace a mano o con diarizacion real;
  el script no lo adivina.
#>

[CmdletBinding()]
param(
  [string]$Path = 'Input',
  [string]$LocalName = 'Local',
  [string]$OnlineName = 'Remotos',
  [int]$MaxMergeMinutes = 2,
  [switch]$KeepFillers,
  [switch]$Force,
  [switch]$SelfTest
)

$ErrorActionPreference = 'Stop'

function Write-Ok($msg)    { Write-Host "OK: $msg" -ForegroundColor Green }
function Write-Abort($msg) { Write-Host "ABORT: $msg" -ForegroundColor Red; exit 1 }
function Write-Warn2($msg) { Write-Host "WARN: $msg" -ForegroundColor Yellow }

# Palabras que por si solas no aportan nada a una sintesis.
$fillerToken = '(?i)^(si|s.|no|nel|nop|ok|oka|okay|aja|aj.|mhm+|mm+|hm+|ujum|uh|huh|ah|eh|este|esta|est.|exacto|exacta|claro|orale|.rale|andale|.ndale|va|vale|listo|perfecto|gracias|hola|adios|adi.s|bueno|buenas|ya|sale|correcto|obvio|pues|osea|o|sea|y|a|ver|de|nada|bien|muy|todo|yep|yes|jum|ahi|ah.|verdad|entonces|nomas|nom.s)$'

function Test-Filler([string]$text) {
  $s = ($text -replace "[.,;:¿?¡!…""'\-]", ' ').Trim()
  if (-not $s) { return $true }
  foreach ($w in ($s -split '\s+')) {
    if ($w -notmatch $fillerToken) { return $false }
  }
  return $true
}

function Add-Chunk([string]$buffer, [string]$chunk) {
  $chunk = $chunk.Trim()
  if (-not $buffer) { return $chunk }
  # tartamudeo: la misma frase repetida pegada
  if ($buffer -eq $chunk -or $buffer.EndsWith(" $chunk")) { return $buffer }
  # cierra la frase anterior si el reconocedor no puso puntuacion
  if ($buffer -notmatch '[.!?…]$') { $buffer += '.' }
  return "$buffer $chunk"
}

function Convert-Transcript($file) {
  $raw = [System.IO.File]::ReadAllText($file.FullName)
  $lines = $raw -split "\r?\n"

  # --- 1. parsear bloques ---
  $blocks = New-Object System.Collections.ArrayList
  $cur = $null
  foreach ($line in $lines) {
    if ($line -match '^(Local|Online)\s+speaker\s+(\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2}):\d{2}\s*$') {
      if ($cur) { [void]$blocks.Add($cur) }
      $hm = $Matches[3] -split ':'
      $cur = @{ Speaker = $Matches[1]; Date = $Matches[2]; Time = $Matches[3]
                Min = [int]$hm[0] * 60 + [int]$hm[1]; Text = '' }
    }
    elseif ($cur -and $line.Trim()) {
      $cur.Text = (("{0} {1}" -f $cur.Text, $line.Trim())).Trim()
    }
  }
  if ($cur) { [void]$blocks.Add($cur) }

  if ($blocks.Count -eq 0) {
    Write-Warn2 "$($file.Name): sin bloques 'Local/Online speaker' - no parece transcripcion de Teams. Saltado."
    return
  }

  # --- 2/3/4. filtrar relleno + fusionar por hablante ---
  $turns = New-Object System.Collections.ArrayList
  $dropped = 0
  foreach ($b in $blocks) {
    if (-not $KeepFillers -and (Test-Filler $b.Text)) { $dropped++; continue }
    $last = if ($turns.Count) { $turns[$turns.Count - 1] } else { $null }
    $elapsed = if ($last) { ($b.Min - $last.Min + 1440) % 1440 } else { 0 }
    $canMerge = $last -and $last.Speaker -eq $b.Speaker -and
                ($MaxMergeMinutes -le 0 -or $elapsed -lt $MaxMergeMinutes)
    if ($canMerge) {
      $last.Text = Add-Chunk $last.Text $b.Text
    } else {
      [void]$turns.Add(@{ Speaker = $b.Speaker; Time = $b.Time; Min = $b.Min; Text = $b.Text.Trim() })
    }
  }

  if ($turns.Count -eq 0) { Write-Warn2 "$($file.Name): todo era relleno. Saltado."; return }

  # --- 5. escribir .md ---
  $out = Join-Path $file.DirectoryName ($file.BaseName + '.md')
  if ((Test-Path $out) -and -not $Force) {
    Write-Abort "$out ya existe. Usa -Force para sobreescribir."
  }

  $date  = $blocks[0].Date
  $start = $blocks[0].Time
  $end   = $blocks[$blocks.Count - 1].Time
  $names = "``$LocalName`` = quien grabo (Local speaker), ``$OnlineName`` = todos los remotos juntos (Online speaker)"

  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine('---')
  [void]$sb.AppendLine('tipo: transcripcion')
  [void]$sb.AppendLine("fuente: `"$($file.Name)`"")
  [void]$sb.AppendLine("fecha: $date")
  [void]$sb.AppendLine("inicio: `"$start`"")
  [void]$sb.AppendLine("fin: `"$end`"")
  [void]$sb.AppendLine("turnos: $($turns.Count)")
  [void]$sb.AppendLine("turnos_crudos: $($blocks.Count)")
  [void]$sb.AppendLine("relleno_descartado: $dropped")
  [void]$sb.AppendLine('tags: [transcripcion]')
  [void]$sb.AppendLine('---')
  [void]$sb.AppendLine()
  [void]$sb.AppendLine("# Transcripcion $date ($start-$end)")
  [void]$sb.AppendLine()
  [void]$sb.AppendLine("> Hablantes: $names. Teams no separa a los remotos entre si.")
  [void]$sb.AppendLine()
  foreach ($t in $turns) {
    $who = if ($t.Speaker -eq 'Local') { $LocalName } else { $OnlineName }
    [void]$sb.AppendLine("**$($t.Time) $who** $($t.Text)")
    [void]$sb.AppendLine()
  }

  [System.IO.File]::WriteAllText($out, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))

  $inKB  = [math]::Round($file.Length / 1KB)
  $outKB = [math]::Round((Get-Item $out).Length / 1KB)
  $pct   = [math]::Round(100 - ($outKB / [math]::Max($inKB, 1) * 100))
  Write-Ok "$($file.Name) -> $(Split-Path $out -Leaf): $($blocks.Count) bloques -> $($turns.Count) turnos, $dropped relleno, ${inKB}KB -> ${outKB}KB (-$pct%)"
}

# --- self-test ---
if ($SelfTest) {
  $tmp = Join-Path $env:TEMP "clean-transcript-selftest.txt"
  @'
Online speaker 2026-01-01 10:00:00
Buenos dias, el pedido

Online speaker 2026-01-01 10:00:05
va a Tijuana

Local speaker 2026-01-01 10:00:10
Aja.

Online speaker 2026-01-01 10:00:12
y el destino operativo es Tultitlan

Local speaker 2026-01-01 10:00:20
71002

Online speaker 2026-01-01 10:05:00
Cinco minutos despues sigo hablando

Online speaker 2026-01-01 10:05:02
Cinco minutos despues sigo hablando
'@ | Set-Content -Path $tmp -Encoding UTF8
  Remove-Item (Join-Path $env:TEMP "clean-transcript-selftest.md") -ErrorAction SilentlyContinue
  Convert-Transcript (Get-Item $tmp)
  $md = [System.IO.File]::ReadAllText((Join-Path $env:TEMP "clean-transcript-selftest.md"))

  $fail = @()
  # fusion de turnos contiguos del mismo hablante, incluso saltando el "Aja." descartado
  if ($md -notmatch 'Buenos dias, el pedido\. va a Tijuana\. y el destino operativo es Tultitlan') { $fail += 'no fusiono los 3 turnos contiguos' }
  # relleno fuera, dato corto dentro
  if ($md -match 'Aja')   { $fail += 'no descarto el relleno "Aja."' }
  if ($md -notmatch '71002') { $fail += 'descarto el dato corto 71002' }
  # corte por tiempo: el bloque de 10:05 no se pega al de 10:00
  if ($md -notmatch '\*\*10:05 ') { $fail += 'no corto el turno a los MaxMergeMinutes' }
  # tartamudeo colapsado
  if (([regex]::Matches($md, 'Cinco minutos despues')).Count -ne 1) { $fail += 'no colapso la frase repetida' }
  if ($md -notmatch 'turnos_crudos: 7') { $fail += 'conteo de bloques crudos incorrecto' }

  Remove-Item $tmp, (Join-Path $env:TEMP "clean-transcript-selftest.md") -ErrorAction SilentlyContinue
  if ($fail) { Write-Abort ("SELFTEST FALLO: " + ($fail -join '; ')) }
  Write-Ok 'SELFTEST OK'
  exit 0
}

# --- entrada ---
if (-not (Test-Path $Path)) { Write-Abort "No existe: $Path" }
$item = Get-Item $Path
$files = if ($item.PSIsContainer) {
  Get-ChildItem -Path $item.FullName -Filter *.txt -File
} else { @($item) }

if (-not $files) { Write-Abort "No hay .txt en $Path" }
foreach ($f in $files) { Convert-Transcript $f }
