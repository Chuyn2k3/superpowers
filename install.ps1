#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Superpowers — Installer & Updater
.DESCRIPTION
    Installs OR updates Antigravity Superpowers skills from GitHub.
    Run locally (after cloning) OR directly from the internet:

    INSTALL / UPDATE (Windows PowerShell):
        irm https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.ps1 | iex

.NOTES
    Repo: https://github.com/Chuyn2k3/superpowers
#>

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
#  Config
# ─────────────────────────────────────────────
$REPO_URL      = "https://github.com/Chuyn2k3/superpowers"
$REPO_ZIP      = "https://github.com/Chuyn2k3/superpowers/archive/refs/heads/main.zip"
$SkillsDir     = Join-Path $env:USERPROFILE ".gemini\antigravity\skills"
$WorkflowsDir  = Join-Path $env:USERPROFILE ".gemini\antigravity\global_workflows"
$VersionFile   = Join-Path $env:USERPROFILE ".gemini\antigravity\.superpowers-version"

# ─────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────
function Write-Step([string]$msg)    { Write-Host "  ▶ $msg" -ForegroundColor Yellow }
function Write-Success([string]$msg) { Write-Host "  ✔ $msg" -ForegroundColor Green }
function Write-Info([string]$msg)    { Write-Host "  ℹ $msg" -ForegroundColor DarkGray }
function Write-Fail([string]$msg)    { Write-Host "  ✖ $msg" -ForegroundColor Red; exit 1 }

function Ensure-Dir([string]$path) {
    if (-Not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Info "Created: $path"
    }
}

# ─────────────────────────────────────────────
#  Detect install vs update
# ─────────────────────────────────────────────
$IsAlreadyInstalled = Test-Path $SkillsDir
$Action = if ($IsAlreadyInstalled) { "UPDATE" } else { "INSTALL" }

# ─────────────────────────────────────────────
#  Banner
# ─────────────────────────────────────────────
$ActionLabel = if ($Action -eq "UPDATE") { "🔄 Updating" } else { "🚀 Installing" }
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   $ActionLabel Antigravity Superpowers         ║" -ForegroundColor Cyan
Write-Host "  ║   https://github.com/Chuyn2k3/superpowers    ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Show previous version if updating
if ($Action -eq "UPDATE" -and (Test-Path $VersionFile)) {
    $PrevVersion = Get-Content $VersionFile -Raw | ConvertFrom-Json
    Write-Info "Current version installed: $($PrevVersion.date) — $($PrevVersion.commit)"
    Write-Host ""
}

# ─────────────────────────────────────────────
#  Detect run mode: piped from web vs local file
# ─────────────────────────────────────────────
$IsRemoteRun = ($PSScriptRoot -eq "" -or $null -eq $PSScriptRoot)

if ($IsRemoteRun) {
    Write-Step "Remote mode — downloading latest from GitHub..."

    $UseGit = $false
    try {
        $null = git --version 2>&1
        if ($LASTEXITCODE -eq 0) { $UseGit = $true }
    } catch {}

    $TempDir = Join-Path $env:TEMP "superpowers-$(Get-Random)"
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

    if ($UseGit) {
        Write-Step "Cloning with git (depth=1)..."
        $oldErrPref = $ErrorActionPreference
        $ErrorActionPreference = "SilentlyContinue"
        $cloneOut = git clone -q --depth 1 $REPO_URL $TempDir 2>&1
        $errCode = $LASTEXITCODE
        $ErrorActionPreference = $oldErrPref
        
        if ($errCode -ne 0) {
            Write-Info "git clone failed, falling back to ZIP..."
            $UseGit = $false
        } else {
            Write-Success "Cloned latest commit."
        }
    }

    if (-Not $UseGit) {
        Write-Step "Downloading ZIP from GitHub..."
        $ZipPath = Join-Path $env:TEMP "superpowers-$(Get-Random).zip"
        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $REPO_ZIP -OutFile $ZipPath -UseBasicParsing
            Write-Step "Extracting..."
            Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
            $Sub = Get-ChildItem -Path $TempDir -Directory | Select-Object -First 1
            if ($Sub) { $TempDir = $Sub.FullName }
            Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue
            Write-Success "Downloaded and extracted."
        } catch {
            Write-Fail "Download failed: $_`nPlease clone manually: git clone $REPO_URL"
        }
    }

    $SourceSkills    = Join-Path $TempDir "skills"
    $SourceWorkflows = Join-Path $TempDir "global_workflows"
    $CleanupDir      = $TempDir

} else {
    Write-Info "Local mode — running from: $PSScriptRoot"
    $SourceSkills    = Join-Path $PSScriptRoot "skills"
    $SourceWorkflows = Join-Path $PSScriptRoot "global_workflows"
    $CleanupDir      = $null
}

# ─────────────────────────────────────────────
#  Install / Update skills
# ─────────────────────────────────────────────
Write-Host ""
$SkillsLabel = if ($Action -eq "UPDATE") { "Updating skills" } else { "Installing skills" }
Write-Step "$SkillsLabel → $SkillsDir"
Ensure-Dir $SkillsDir

if (Test-Path $SourceSkills) {
    Copy-Item -Path "$SourceSkills\*" -Destination $SkillsDir -Recurse -Force
    Write-Success "Skills $($Action.ToLower())d."
} else {
    Write-Fail "Skills directory not found at: $SourceSkills"
}

# ─────────────────────────────────────────────
#  Install / Update global_workflows
# ─────────────────────────────────────────────
if (Test-Path $SourceWorkflows) {
    $WfLabel = if ($Action -eq "UPDATE") { "Updating workflows" } else { "Installing workflows" }
    Write-Step "$WfLabel → $WorkflowsDir"
    Ensure-Dir $WorkflowsDir
    Copy-Item -Path "$SourceWorkflows\*" -Destination $WorkflowsDir -Recurse -Force
    Write-Success "Global workflows $($ACTION.ToLower())d."
} else {
    Write-Info "No global_workflows found — skipping."
}

# ─────────────────────────────────────────────
#  Save version stamp
# ─────────────────────────────────────────────
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$CommitHash = ""
if ($CleanupDir -and (Test-Path (Join-Path $CleanupDir ".git"))) {
    try { $CommitHash = (git -C $CleanupDir rev-parse --short HEAD 2>&1) } catch {}
} elseif ($null -eq $CleanupDir) {
    try { $CommitHash = (git -C $PSScriptRoot rev-parse --short HEAD 2>&1) } catch {}
}

$VersionInfo = @{ date = $Timestamp; commit = $CommitHash; action = $Action } | ConvertTo-Json
$VersionInfo | Set-Content -Path $VersionFile -Encoding UTF8
Write-Info "Version stamp saved."

# ─────────────────────────────────────────────
#  Cleanup temp (remote mode only)
# ─────────────────────────────────────────────
if ($CleanupDir -and (Test-Path $CleanupDir)) {
    # Go up one level if needed
    $CleanRoot = Split-Path $CleanupDir -Parent
    if ($CleanRoot -eq $env:TEMP) {
        Remove-Item -Path $CleanupDir -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Remove-Item -Path $CleanRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ─────────────────────────────────────────────
#  Done
# ─────────────────────────────────────────────
$DoneLabel = if ($Action -eq "UPDATE") { "✅ Update complete!" } else { "✅ Installation complete!" }
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║  $DoneLabel                          ║" -ForegroundColor Green
Write-Host "  ║                                              ║" -ForegroundColor Green
Write-Host "  ║  Skills    → $SkillsDir" -ForegroundColor Green
Write-Host "  ║                                              ║" -ForegroundColor Green
Write-Host "  ║  To update later, run the same command again ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
