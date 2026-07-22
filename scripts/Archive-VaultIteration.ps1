<#
.SYNOPSIS
  Archive-VaultIteration.ps1 - Archiva el contenido activo del vault Zettelkasten.

.DESCRIPTION
  Mueve el contenido activo (Inbox/, Input/, Journal/, Output/) de la raiz del vault
  a la carpeta UNICA _Archivo/ (con subcarpetas Inbox/Input/Journal/Output). Recrea
  las carpetas activas vacias. Reubica PNG sueltos en Imagenes/.

  Modelo de carpeta unica: NO crea 0xxx_Archivo/ numeradas. Siempre mueve a _Archivo/.
  Esto evita la proliferacion de carpetas de migracion en el repo.

  REGLA DE DUPLICADOS: si un archivo activo tiene el mismo nombre que uno ya archivado:
  - Si activo.mtime >= archivado.mtime -> el activo reemplaza al archivado.
  - Si activo.mtime <  archivado.mtime -> el script salta el activo (preserva el archivado).

  NUNCA toca Memoria/ - la memoria del agente es persistente y transversal.
  Imagenes/ permanece intacta en su estructura (solo recibe nuevos PNG sueltos).

.PARAMETER KeepCurrentJournal
  Si se establece, excluye el journal mas nuevo (detectado automaticamente o el
  indicado por -JournalDate) y sus imagenes referenciadas - ambos se quedan en raiz
  como contenido activo. Por defecto (sin flag), se archiva todo.

.PARAMETER JournalDate
  Override del auto-detect del journal a mantener cuando se usa -KeepCurrentJournal.
  Formato: YYYY-MM-DD.

.PARAMETER WhatIf
  Dry-run estandar de PowerShell. Previsualiza sin tocar nada.

.EXAMPLE
  powershell -File scripts\Archive-VaultIteration.ps1 -WhatIf
  powershell -File scripts\Archive-VaultIteration.ps1
  powershell -File scripts\Archive-VaultIteration.ps1 -KeepCurrentJournal
  powershell -File scripts\Archive-VaultIteration.ps1 -KeepCurrentJournal -JournalDate 2026-07-15

.NOTES
  Compatible con PowerShell 5.1+ y PowerShell 7+ (pwsh).
  Restriccion: este script no maneja git ni credenciales. Usa /git-full despues.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [switch]$KeepCurrentJournal,
  [string]$JournalDate
)

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$archiveName = '_Archivo'
$archivePath = Join-Path $root $archiveName

function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "OK: $msg" -ForegroundColor Green }
function Write-Abort($msg) { Write-Host "ABORT: $msg" -ForegroundColor Red; exit 1 }
function Write-Warn2($msg){ Write-Host "WARN: $msg" -ForegroundColor Yellow }

# --- 1. validar raiz ---
Write-Step "Validando raiz del vault"
foreach ($f in 'Inbox','Input','Journal','Output','Imagenes','Zettelkasten') {
  if (-not (Test-Path -LiteralPath (Join-Path $root $f))) {
    Write-Abort "No se encontro carpeta requerida '$f' en raiz. No parece un vault Zettelkasten valido."
  }
}

$activeInbox   = Get-ChildItem -LiteralPath 'Inbox'   -File -ErrorAction SilentlyContinue
$activeInput   = Get-ChildItem -LiteralPath 'Input'   -File -ErrorAction SilentlyContinue
$activeInputDirs = Get-ChildItem -LiteralPath 'Input' -Directory -ErrorAction SilentlyContinue
$activeJournal = Get-ChildItem -LiteralPath 'Journal' -File -Filter *.md -ErrorAction SilentlyContinue
$activeOutput  = Get-ChildItem -LiteralPath 'Output'   -File -ErrorAction SilentlyContinue
$activeOutputDirs = Get-ChildItem -LiteralPath 'Output' -Directory -ErrorAction SilentlyContinue

$hasContent = ($activeInbox) -or ($activeInput) -or ($activeInputDirs) -or ($activeJournal) -or ($activeOutput) -or ($activeOutputDirs)
if (-not $hasContent) {
  Write-Abort "Inbox, Input, Journal, Output estan todas vacias. Nada que archivar."
}
Write-Ok "Hay contenido activo para archivar."

# --- 2. asegurar _Archivo/ con subcarpetas ---
Write-Step "Asegurando $archiveName/ con subcarpetas"
foreach ($sub in 'Inbox','Input','Journal','Output') {
  $p = Join-Path $archivePath $sub
  if (-not (Test-Path -LiteralPath $p)) {
    if ($PSCmdlet.ShouldProcess($p, 'Crear subcarpeta')) {
      New-Item -ItemType Directory -Path $p -Force | Out-Null
    }
  }
}
# NotasPlanas/ solo existe si el usuario ha migrado notas planas legacy; no crear
# automaticamente (no forma parte del flujo canonico).

# --- 3. mover contenido activo a _Archivo/ con regla de duplicados mtime ---
# Returns: @{ Moved = N; Skipped = N; Replaced = N }
function Move-WithDedup($src, $dst) {
  $result = @{ Moved = 0; Skipped = 0; Replaced = 0 }
  if (-not (Test-Path -LiteralPath $src)) { return $result }
  $items = Get-ChildItem -LiteralPath $src -Force | Where-Object { $_.Name -ne '.gitkeep' }
  if (-not $items) { return $result }
  foreach ($i in $items) {
    $targetPath = Join-Path $dst $i.Name
    if (Test-Path -LiteralPath $targetPath) {
      # Duplicado: comparar mtime
      try {
        $srcTime = $i.LastWriteTime
        $dstItem = Get-Item -LiteralPath $targetPath
        $dstTime = $dstItem.LastWriteTime
        if ($srcTime -ge $dstTime) {
          if ($PSCmdlet.ShouldProcess("$($i.FullName) -gt $targetPath (reemplaza archivado, mtime mas reciente)", 'Mover (reemplazo)')) {
            Move-Item -LiteralPath $i.FullName -Destination $dst -Force
            $result.Replaced++
          }
        } else {
          # El archivado es mas reciente; saltar el activo
          Write-Warn2 "Saltando $($i.Name): archivado tiene mtime mas reciente ($dstTime > $srcTime)"
          $result.Skipped++
        }
      } catch {
        Write-Warn2 "Error comparando $($i.Name): $_. Saltando por seguridad."
        $result.Skipped++
      }
    } else {
      if ($PSCmdlet.ShouldProcess("$($i.FullName) -gt $dst", 'Mover')) {
        if ($i.PSIsContainer) {
          Move-Item -LiteralPath $i.FullName -Destination $dst -Force
        } else {
          Move-Item -LiteralPath $i.FullName -Destination $dst -Force
        }
        $result.Moved++
      }
    }
  }
  return $result
}

Write-Step "Moviendo contenido activo a $archiveName/ (con regla mtime duplicados)"
$rInbox   = Move-WithDedup 'Inbox'   (Join-Path $archivePath 'Inbox')
$rInput   = Move-WithDedup 'Input'   (Join-Path $archivePath 'Input')
$rJournal = Move-WithDedup 'Journal' (Join-Path $archivePath 'Journal')
$rOutput  = Move-WithDedup 'Output'  (Join-Path $archivePath 'Output')

# --- 4. mover PNG sueltos de raiz a Imagenes/ ---
Write-Step "Reubicando PNG sueltos en Imagenes/"
$rootPngs = Get-ChildItem -LiteralPath $root -File -Filter *.png -ErrorAction SilentlyContinue
$pngMoved = 0; $pngKept = 0
if ($rootPngs) {
  $referenced = @()
  if ($KeepCurrentJournal) {
    $journalName = $null
    if ($JournalDate) {
      $journalName = "$JournalDate.md"
    } else {
      $jf = Get-ChildItem -LiteralPath 'Journal' -File -Filter *.md -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
      if ($jf) { $journalName = $jf.Name }
    }
    if ($journalName) {
      $journalPath = Join-Path $root "Journal\$journalName"
      if (Test-Path -LiteralPath $journalPath) {
        $jcontent = Get-Content -LiteralPath $journalPath -Raw
        $referenced = [regex]::Matches($jcontent, '!\[\[([^\]]+?\.png)\]\]', 'IgnoreCase') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
        Write-Host "Journal activo: $journalName (mantiene $($referenced.Count) imagenes referenciadas)" -ForegroundColor Yellow
      }
    }
  }
  foreach ($p in $rootPngs) {
    if ($referenced -contains $p.Name) { $pngKept++ ; continue }
    $targetImg = Join-Path 'Imagenes' $p.Name
    $shouldMove = $true
    if (Test-Path -LiteralPath $targetImg) {
      $srcT = $p.LastWriteTime
      $dstT = (Get-Item -LiteralPath $targetImg).LastWriteTime
      if ($srcT -lt $dstT) {
        Write-Warn2 "Saltando PNG $($p.Name): Imagenes/ ya tiene mtime mas reciente"
        $pngKept++; $shouldMove = $false
      }
    }
    if ($shouldMove) {
      if ($PSCmdlet.ShouldProcess("$($p.FullName) -gt $targetImg", 'Mover PNG')) {
        Move-Item -LiteralPath $p.FullName -Destination 'Imagenes' -Force
        $pngMoved++
      }
    }
  }
}

# --- 5. recrear carpetas activas vacias + .gitkeep ---
Write-Step "Recreando carpetas activas vacias en raiz"
foreach ($f in 'Inbox','Input','Journal','Output') {
  $p = Join-Path $root $f
  if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
  $gk = Join-Path $p '.gitkeep'
  if (-not (Test-Path -LiteralPath $gk)) { New-Item -ItemType File -Path $gk -Force | Out-Null }
}

# --- 6. actualizar _Archivo/migration.md seccion "Estado actual" ---
Write-Step "Actualizando $archiveName/migration.md seccion Estado actual"
$migPath = Join-Path $archivePath 'migration.md'
if (Test-Path -LiteralPath $migPath) {
  if ($PSCmdlet.ShouldProcess($migPath, 'Actualizar seccion Estado actual')) {
    $mig = Get-Content -LiteralPath $migPath -Raw

    # Recomputar rango y conteo de journals archivados
    $archivedJournals = Get-ChildItem -LiteralPath (Join-Path $archivePath 'Journal') -File -Filter *.md -ErrorAction SilentlyContinue
    $jCount = if ($archivedJournals) { $archivedJournals.Count } else { 0 }
    if ($archivedJournals) {
      $sorted = $archivedJournals.Name | ForEach-Object { if ($_ -match '(\d{4}-\d{2}-\d{2})') { $matches[1] } } | Sort-Object -Unique
      if ($sorted.Count -gt 1) { $jRange = "$($sorted[0]) a $($sorted[-1])" }
      elseif ($sorted.Count -eq 1) { $jRange = $sorted[0] }
      else { $jRange = "sin journals" }
    } else { $jRange = "sin journals" }

    # Journal activo restante (si KeepCurrentJournal)
    $activeJNow = Get-ChildItem -LiteralPath 'Journal' -File -Filter *.md -ErrorAction SilentlyContinue
    $jActiveStr = if ($activeJNow) {
      $ajNames = ($activeJNow.Name) -join ', '
      "Activo: $ajNames"
    } else { "ninguno (todos archivados)" }

    $totalArchived = (Get-ChildItem -LiteralPath $archivePath -Recurse -File | Where-Object { $_.Name -ne '.gitkeep' -and $_.Name -ne 'migration.md' }).Count

    # Reemplazar la seccion 7 "Estado actual" entera
    $todayStr = Get-Date -Format 'yyyy-MM-dd'
    $newSec = @"
## 7. Estado actual

- **Journals archivados**: $jCount (rango $jRange)
- **Journal activo**: $jActiveStr
- **Total en `_Archivo/`**: $totalArchived archivos
- **Ultimo archivado**: $todayStr
"@
    # Reemplazar desde "## N. Estado actual" hasta el siguiente "## " o fin de seccion
    $pattern = '(?ms)^## \d+\. Estado actual.*?(?=^## |\Z)'
    if ($mig -match $pattern) {
      $mig = $mig -replace $pattern, ($newSec + "`r`n`r`n")
    }
    # Actualizar fecha de ultima actualizacion
    $mig = $mig -replace '\*Ultima actualizacion:.*?\*', ('*Ultima actualizacion: ' + $todayStr + ' - ArchivadoAutomatico*')
    Set-Content -LiteralPath $migPath -Value $mig -Encoding UTF8 -NoNewline
  }
}

# --- resumen ---
$totMoved = $rInbox.Moved + $rInput.Moved + $rJournal.Moved + $rOutput.Moved
$totReplaced = $rInbox.Replaced + $rInput.Replaced + $rJournal.Replaced + $rOutput.Replaced
$totSkipped = $rInbox.Skipped + $rInput.Skipped + $rJournal.Skipped + $rOutput.Skipped
$summary = "Archivado a $archiveName/: $totMoved movidos, $totReplaced reemplazados (mtime reciente), $totSkipped saltados (archivado mas reciente)"
if ($KeepCurrentJournal) { $summary += " | modo keep: journal activo preservado" }
$summary += " | $pngMoved PNG a Imagenes/ ($pngKept preservados)"
Write-Host ""
Write-Ok $summary