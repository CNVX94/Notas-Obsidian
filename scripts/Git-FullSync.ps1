<#
.SYNOPSIS
  Git-FullSync.ps1 - Flujo git add + commit + push para el vault.

.DESCRIPTION
  Ejecuta `git add -A` + `git commit` + `git push`. Maneja setup interactivo de
  remote si no existe origin. Mensaje de commit default: "vault sync YYYY-MM-DD HH:mm".

  ################################################################################
  RESTRICCION HARD - LEE ANTES DE CUALQUIER USO O MODIFICACION
  ################################################################################
  - El agente NUNCA se configura como colaborador del repo GitHub.
  - El agente NUNCA genera identidad propia ni credenciales propias.
  - El agente NUNCA escribe PATs, tokens ni secretos a Memoria/ ni a ningun
    archivo del repo.
  - La autenticacion vive en Git Credential Manager (GCM), encriptada por el SO.
    Si no esta configurado, este script aborta y sugiere configurarlo.
  - Si el usuario pide "guardo el PAT en Memoria" -> REHUSA. Replica esta
    restriccion. Sugiere configurar GCM.
  ################################################################################

.PARAMETER Message
  Mensaje de commit. Si no se pasa, se genera: "vault sync YYYY-MM-DD HH:mm".

.PARAMETER WhatIf
  Dry-run estandar de PowerShell. Previsualiza sin hacer git add/commit/push.

.EXAMPLE
  pwsh scripts/Git-FullSync.ps1 -WhatIf
  pwsh scripts/Git-FullSync.ps1
  pwsh scripts/Git-FullSync.ps1 -Message "feat: agregar MOC de IA"
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string]$Message
)

$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path

function Write-Step($msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "OK: $msg" -ForegroundColor Green }
function Write-Abort($msg) { Write-Host "ABORT: $msg" -ForegroundColor Red; exit 1 }
function Write-Warn2($msg){ Write-Host "WARN: $msg" -ForegroundColor Yellow }

# --- 0. validar git ---
Write-Step "Validando repositorio git"
if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) {
  Write-Abort "No es un repositorio git. Corre 'git init' y vuelve a intentar."
}

# verificar GCM configurado (no aborta, solo advierte una vez)
$helper = git config --global credential.helper 2>$null
if (-not $helper) {
  Write-Warn2 "Git Credential Manager no detectado (credential.helper vacio)."
  Write-Warn2 "Si el primer push falla por auth, ejecuta: git config --global credential.helper manager"
  Write-Warn2 "Luego autenticate en el dialogo nativo de Windows (se pide UNA sola vez)."
  Write-Host ""
}

# --- 1. cambios pendientes ---
Write-Step "Revisando cambios pendientes"
$status = git status --porcelain 2>$null
if (-not $status) {
  Write-Abort "No hay cambios para commitear (working tree limpio)."
}
$changesCount = ($status | Measure-Object).Count
Write-Ok "$changesCount cambios detectados."

# --- 2. remote setup interactivo ---
Write-Step "Verificando remote origin"
$remote = git remote get-url origin 2>$null
if (-not $remote) {
  Write-Warn2 "No hay git remote 'origin' configurado."
  Write-Host "Asegurate de haber creado el repo en GitHub primero." -ForegroundColor DarkGray
  if (-not $PSCmdlet.ShouldProcess('origin', 'Configurar remote (prompt interactivo)')) {
    Write-Abort "Dry-run: no se configurara remote en WhatIf."
  }
  $remoteUrl = Read-Host "Pega la URL del repo GitHub (ej: https://github.com/USER/REPO.git)"
  if (-not $remoteUrl) { Write-Abort "URL vacia. Abortando." }
  git remote add origin $remoteUrl
  $remote = $remoteUrl
  Write-Ok "Remote origin configurado: $remote"
} else {
  Write-Ok "Remote origin: $remote"
}

# --- 3. mensaje de commit ---
if (-not $Message) {
  $Message = 'vault sync ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
}
Write-Step "Mensaje de commit: $Message"

# --- 4. add + commit ---
if (-not $PSCmdlet.ShouldProcess('git add -A', 'Ejecutar')) {
  Write-Abort "Dry-run: no se hara git add en WhatIf."
}
git add -A

if (-not $PSCmdlet.ShouldProcess("git commit -m `"$Message`"", 'Ejecutar')) {
  Write-Abort "Dry-run: no se hara git commit en WhatIf."
}
$commitOut = git commit -m $Message 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Abort "git commit fallo: $commitOut"
}
$commitHash = (git rev-parse --short HEAD 2>$null)
Write-Ok "Commit creado: $commitHash"

# --- 5. push ---
Write-Step "Detectando rama y upstream"
$branch = git branch --show-current 2>$null
if (-not $branch) { $branch = 'main' }

$hasUpstream = $true
try { git rev-parse --abbrev-ref '@{u}' 2>$null | Out-Null } catch { $hasUpstream = $false }

if (-not $PSCmdlet.ShouldProcess("git push origin $branch", 'Ejecutar')) {
  Write-Abort "Dry-run: no se hara git push en WhatIf."
}

if (-not $hasUpstream) {
  Write-Host "Primer push: configurando upstream con -u origin $branch" -ForegroundColor DarkGray
  $pushOut = git push -u origin HEAD 2>&1
} else {
  $pushOut = git push origin $branch 2>&1
}

if ($LASTEXITCODE -ne 0) {
  $pushErr = ($pushOut | Out-String)
  Write-Host ""
  Write-Host "git push fallo:" -ForegroundColor Red
  Write-Host $pushErr
  Write-Host ""
  if ($pushErr -match 'could not|Authentication failed|403|401|credentials') {
    Write-Warn2 "Problema de autenticacion. Configura Git Credential Manager:"
    Write-Host "    git config --global credential.helper manager" -ForegroundColor Cyan
    Write-Host "Vuelve a correr /git-full. El dialogo nativo de Windows aparecera UNA sola vez." -ForegroundColor DarkGray
    exit 2
  }
  if ($pushErr -match 'non-fast-forward|rejected|fetch first') {
    Write-Warn2 "El remoto esta adelante. Necesitaras rebase:"
    Write-Host "    git pull --rebase origin $branch" -ForegroundColor Cyan
    Write-Host "Luego vuelve a correr /git-full." -ForegroundColor DarkGray
    exit 3
  }
  Write-Abort "git push fallo por razon no cubierta (ver output arriba)."
}

# --- resumen ---
Write-Host ""
Write-Ok "Pushed a origin/$branch"
Write-Host "Repo: $remote"
Write-Host "Mensaje: $Message"
Write-Host "Accion via credenciales del usuario (GCM). El agente NO es colaborador del repo." -ForegroundColor DarkGray