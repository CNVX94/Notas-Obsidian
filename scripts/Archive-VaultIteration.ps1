<#
.SYNOPSIS
  Archive-VaultIteration.ps1 - Archiva la iteracion actual del vault Zettelkasten.

.DESCRIPTION
  Mueve el contenido activo (Inbox/, Input/, Journal/, Output/) de la raiz del vault
  a una nueva carpeta 0xxx_Archivo/, reubica PNG sueltos en Imagenes/, recrea las
  carpetas activas vacias, y actualiza la documentacion (migration.md, README.md,
  AGENTS.md references).

  NUNCA toca Memoria/ — la memoria del agente es persistente y transversal a
  iteraciones. Memoria/ NO se archiva.

.PARAMETER KeepCurrentJournal
  Si se establece, excluye el journal mas nuevo (detectado automaticamente o el
  indicado por -JournalDate) y sus imagenes referenciadas — ambos se quedan en raiz
  como contenido activo. Por defecto (sin flag), se archiva todo.

.PARAMETER JournalDate
  Override del auto-detect del journal a mantener cuando se usa -KeepCurrentJournal.
  Formato: YYYY-MM-DD. Util si el journal mas nuevo no es el que quieres mantener.

.PARAMETER WhatIf
  Dry-run estandar de PowerShell. Previsualiza sin tocar nada.

.EXAMPLE
  pwsh scripts/Archive-VaultIteration.ps1 -WhatIf
  pwsh scripts/Archive-VaultIteration.ps1
  pwsh scripts/Archive-VaultIteration.ps1 -KeepCurrentJournal
  pwsh scripts/Archive-VaultIteration.ps1 -KeepCurrentJournal -JournalDate 2026-07-15

.NOTES
  Restriccion: este script no maneja git ni credenciales. Usa /git-full despues.
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [switch]$KeepCurrentJournal,
  [string]$JournalDate
)

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path

# --- helpers ---
function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "OK: $msg" -ForegroundColor Green }
function Write-Abort($msg) { Write-Host "ABORT: $msg" -ForegroundColor Red; exit 1 }

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

# --- 2. calcular siguiente iteracion ---
Write-Step "Calculando siguiente numero de iteracion"
$existing = Get-ChildItem -LiteralPath $root -Directory | Where-Object { $_.Name -match '^\d{4}_Archivo$' } | Sort-Object Name -Descending
if ($existing) {
  $lastNum = [int]($existing[0].Name.Substring(0,4))
  $nextNum = $lastNum + 1
  $prevName = $existing[0].Name
} else {
  $lastNum = 0
  $nextNum = 1
  $prevName = $null
}
$nextName = ('{0:D4}_Archivo' -f $nextNum)
$nextPath = Join-Path $root $nextName
if (Test-Path -LiteralPath $nextPath) {
  Write-Abort "La carpeta '$nextName' ya existe. Abortando para no sobreescribir."
}
Write-Ok "Proxima iteracion: $nextName"

if ($PSCmdlet.ShouldProcess($nextName, 'Crear estructura')) {
  foreach ($sub in 'Inbox','Input','Journal','Output') {
    New-Item -ItemType Directory -Path (Join-Path $nextPath $sub) -Force | Out-Null
  }
}

# --- 3. mover contenido activo (NO Memoria/) ---
function Move-FolderContents($src, $dst) {
  if (-not (Test-Path -LiteralPath $src)) { return 0 }
  $items = Get-ChildItem -LiteralPath $src -Force | Where-Object { $_.Name -ne '.gitkeep' }
  if (-not $items) { return 0 }
  if ($PSCmdlet.ShouldProcess("$src -> $dst", ('Mover {0} items' -f $items.Count))) {
    foreach ($i in $items) {
      Move-Item -LiteralPath $i.FullName -Destination $dst -Force
    }
  }
  return $items.Count
}

Write-Step "Moviendo contenido activo a $nextName"
$nInbox   = Move-FolderContents 'Inbox'   (Join-Path $nextPath 'Inbox')
$nInput   = Move-FolderContents 'Input'   (Join-Path $nextPath 'Input')
$nJournal = Move-FolderContents 'Journal' (Join-Path $nextPath 'Journal')
$nOutput  = Move-FolderContents 'Output'  (Join-Path $nextPath 'Output')

# --- 4. invocar plantilla migration.md ---
Write-Step "Generando $nextName/migration.md"
if ($PSCmdlet.ShouldProcess("$nextName/migration.md", 'Escribir')) {
  $journalMoved = Get-ChildItem -LiteralPath (Join-Path $nextPath 'Journal') -File -ErrorAction SilentlyContinue
  if ($journalMoved) {
    $dates = $journalMoved.Name | ForEach-Object { if ($_ -match '(\d{4}-\d{2}-\d{2})') { $matches[1] } } | Sort-Object -Unique
    $jRange = if ($dates.Count -gt 1) { "$($dates[0]) a $($dates[-1])" } elseif ($dates.Count -eq 1) { $dates[0] } else { "sin journals" }
    $jCount = $journalMoved.Count
  } else {
    $jRange = "sin journals"; $jCount = 0
  }
  $keepNote = if ($KeepCurrentJournal) { "`n`n### Excepcion de esta iteracion`nEl journal mas nuevo se mantuvo **activo** en \`Journal/\` raiz. Sus imagenes referenciadas se quedaron en raiz. En la proxima archivacion, mover ese journal y sus imagenes a \`Imagenes/\`." } else { "" }

  $tpl = @"
# Migration Guide - Vault Zettelkasten (Iteracion $nextNum)

> **Punto de entrada para agentes de IA.** Lee este archivo primero para entender la estructura del vault.

---

## 1. Mapa del vault

\`\`\`
<vault>/
+- $nextName/          <- Iteracion $nextNum (esta guia)
|  +- Inbox/   Input/   Journal/   Output/
|  +- migration.md    <- ESTE ARCHIVO
+- Imagenes/           <- Todas las imagenes
+- Inbox/  Input/  Journal/  Output/   <- carpetas activas (vacias)
+- Zettelkasten/       <- MOCs y plantillas
+- Memoria/            <- PERSISTENTE, no se archiva
+- scripts/            <- Archive-VaultIteration.ps1, Git-FullSync.ps1
+- AGENTS.md
+- README.md
\`\`\`

## 2. Contenido archivado en esta iteracion
- Inbox: $nInbox archivos
- Input: $nInput archivos o subcarpetas
- Journal: $jCount archivos ($jRange)
- Output: $nOutput archivos o subcarpetas$keepNote

---

## 3. Flujo Zettelkasten
\`\`\`
Journal -> Inbox -> Input -> Zettelkasten -> Output
\`\`\`
Ver \`AGENTS.md\` seccion 2 para reglas de enrutamiento.

## 4. Memoria del agente
\`Memoria/\` **no se archiva nunca**. Es persistente entre iteraciones. Ver \`AGENTS.md\` seccion 4.

## 5. Archivacion futura
Usa el comando \`/archive-vault\` para la proxima iteracion:
- \`/archive-vault\` (default) — archiva todo.
- \`/archive-vault keep\` — excluye el journal mas nuevo y sus imagenes.
- \`/archive-vault all\` — alias del default.

Memoria/ nunca se toca.

## 6. Auto-trabajo (agente IA)
1. Lee este archivo y \`AGENTS.md\` primero.
2. Busca con grep/glob en carpetas relevantes.
3. Procesa segun tipo (crear, organizar, archivar, etc.).
4. Verifica carpetas y tags.
5. Reporta que se hizo.

---

*Ultima actualizacion: $(Get-Date -Format 'yyyy-MM-dd') - Iteracion $nextNum archivada*
"@
  Set-Content -LiteralPath (Join-Path $nextPath 'migration.md') -Value $tpl -Encoding UTF8 -NoNewline
}

# --- 5. marcar migration.md previo como historica ---
if ($prevName) {
  $prevMigrationPath = Join-Path $root "$prevName\migration.md"
  if (Test-Path -LiteralPath $prevMigrationPath) {
    Write-Step "Marcando $prevName/migration.md como HISTORICA"
    if ($PSCmdlet.ShouldProcess("$prevName/migration.md", 'Editar encabezado historico')) {
      $old = Get-Content -LiteralPath $prevMigrationPath -Raw -ErrorAction SilentlyContinue
      if ($old -and $old -notmatch 'HISTORICA') {
        $old = $old -replace '(?m)^# Migration Guide.*$', "# Migration Guide - Vault Zettelkasten (Iteracion $lastNum) - HISTORICA`n`n> **Archivo historico de la iteracion $lastNum.** Para la guia actual, leer ``$nextName/migration.md``."
        $old = $old -replace '\*Ultima actualizacion:.*?\*', ('*Ultima actualizacion: ' + (Get-Date -Format 'yyyy-MM-dd') + ' - Iteracion ' + $lastNum + ' archivada; guia activa movida a ``' + $nextName + '/migration.md``*')
        Set-Content -LiteralPath $prevMigrationPath -Value $old -Encoding UTF8 -NoNewline
      }
    }
  }
}

# --- 6. mover PNG sueltos de raiz a Imagenes/ (excepto los del journal activo si -KeepCurrentJournal) ---
Write-Step "Reubicando PNG sueltos en Imagenes/"
$rootPngs = Get-ChildItem -LiteralPath $root -File -Filter *.png -ErrorAction SilentlyContinue
$toMove = @(); $toKeep = @()
if ($rootPngs) {
  $referenced = @()
  if ($KeepCurrentJournal) {
    $journalName = if ($JournalDate) { "$JournalDate.md" } else { (Get-ChildItem -LiteralPath 'Journal' -File -Filter *.md -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1).Name }
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
    if ($referenced -contains $p.Name) { $toKeep += $p } else { $toMove += $p }
  }
  if ($toMove) {
    if ($PSCmdlet.ShouldProcess("$($toMove.Count) PNG -> Imagenes/", 'Mover')) {
      foreach ($p in $toMove) { Move-Item -LiteralPath $p.FullName -Destination 'Imagenes' -Force }
    }
  }
}
$imgMoved = $toMove.Count; $imgKept = $toKeep.Count

# --- 7. recrear carpetas activas vacias + .gitkeep ---
Write-Step "Recreando carpetas activas vacias en raiz"
foreach ($f in 'Inbox','Input','Journal','Output') {
  $p = Join-Path $root $f
  if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
  $gk = Join-Path $p '.gitkeep'
  if (-not (Test-Path -LiteralPath $gk)) { New-Item -ItemType File -Path $gk -Force | Out-Null }
}

# --- 8. actualizar README.md y AGENTS.md con la nueva iteracion ---
Write-Step "Actualizando README.md y AGENTS.md con $nextName"
if ($PSCmdlet.ShouldProcess('README.md', 'Actualizar mapa y referencia')) {
  $readme = Get-Content -LiteralPath 'README.md' -Raw -ErrorAction SilentlyContinue
  if ($readme) {
    $readme = $readme -replace '(?m)^\| `/archive-vault` \|.*$', '| `/archive-vault` | Archiva iteracion (default: archiva todo). Mueve Inbox/Input/Journal/Output a nueva `0xxx_Archivo/`, reubica imagenes en `Imagenes/`, recrea carpetas activas. |'
    if ($readme -notmatch [regex]::Escape($nextName)) {
      $readme = $readme -replace '(?m)^(├── )(000\d_Archivo/.*?)(\s*←.*)*$', "`$1$nextName/            ← Iteracion $nextNum (actual)`$3"
      $readme = $readme -replace '(?m)^├── 0001_Archivo/', "├── 0001_Archivo/            ← Iteracion 1 (archivada)"
      $readme = $readme -replace "(?m)^\| ``$prevName`` \|(.*?actual.*?\|)", "| ``$nextName`` |`$1"
    }
    Set-Content -LiteralPath 'README.md' -Value $readme -Encoding UTF8 -NoNewline
  }
}

if ($PSCmdlet.ShouldProcess('AGENTS.md', 'Actualizar referencia a migration.md')) {
  $agents = Get-Content -LiteralPath 'AGENTS.md' -Raw -ErrorAction SilentlyContinue
  if ($agents) {
    $agents = $agents -replace '0\d{3}_Archivo/migration\.md', "$nextName/migration.md"
    Set-Content -LiteralPath 'AGENTS.md' -Value $agents -Encoding UTF8 -NoNewline
  }
}

# actualizar opencode.json instructions
$ocPath = '.opencode\opencode.json'
if (Test-Path -LiteralPath $ocPath) {
  if ($PSCmdlet.ShouldProcess('.opencode/opencode.json', 'Actualizar instructions')) {
    $oc = Get-Content -LiteralPath $ocPath -Raw
    $oc = $oc -replace '0\d{3}_Archivo/migration\.md', "$nextName/migration.md"
    Set-Content -LiteralPath $ocPath -Value $oc -Encoding UTF8 -NoNewline
  }
}

# --- resumen ---
$summary = "Archivada iteracion $lastNum -> $nextName"
if ($KeepCurrentJournal) { $summary += " (modo keep: journal activo preservado)" }
$summary += ": $nInbox Inbox, $nInput Input, $jCount Journal, $nOutput Output; $imgMoved imagenes -> Imagenes/ ($imgKept referenciadas preservadas)"
Write-Host ""
Write-Ok $summary