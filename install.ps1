#Requires -Version 5.1
<#
.SYNOPSIS
    Antigravity Superpowers Installer
.DESCRIPTION
    Installs Antigravity Superpowers skills to the local Antigravity directory.
    Can be run locally (after cloning) OR directly from the internet via:
        irm https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.ps1 | iex
.NOTES
    Author: Chuyn2k3
    Repo  : https://github.com/Chuyn2k3/superpowers
#>

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
#  Banner
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║    🚀 Antigravity Superpowers Installer       ║" -ForegroundColor Cyan
Write-Host "  ║       https://github.com/Chuyn2k3/superpowers ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────
#  Detect run mode: piped from web vs local file
# ─────────────────────────────────────────────
$IsRemoteRun = ($PSScriptRoot -eq "" -or $PSScriptRoot -eq $null)

$REPO_URL   = "https://github.com/Chuyn2k3/superpowers"
$REPO_ZIP   = "https://github.com/Chuyn2k3/superpowers/archive/refs/heads/main.zip"
$SkillsDir  = Join-Path $env:USERPROFILE ".gemini\antigravity\skills"
$WorkflowsDir = Join-Path $env:USERPROFILE ".gemini\antigravity\global_workflows"

# ─────────────────────────────────────────────
#  Helper functions
# ─────────────────────────────────────────────
function Write-Step([string]$msg) {
    Write-Host "  ▶ $msg" -ForegroundColor Yellow
}

function Write-Success([string]$msg) {
    Write-Host "  ✔ $msg" -ForegroundColor Green
}

function Write-Info([string]$msg) {
    Write-Host "  ℹ $msg" -ForegroundColor DarkGray
}

function Ensure-Dir([string]$path) {
    if (-Not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Info "Created directory: $path"
    }
}

# ─────────────────────────────────────────────
#  REMOTE MODE: Download & install from GitHub
# ─────────────────────────────────────────────
if ($IsRemoteRun) {
    Write-Step "Remote install detected — downloading from GitHub..."

    # Check for git first (preferred), fallback to zip download
    $UseGit = $false
    try {
        $gitVersion = git --version 2>&1
        if ($LASTEXITCODE -eq 0) { $UseGit = $true }
    } catch {}

    $TempDir = Join-Path $env:TEMP "superpowers-install-$(Get-Random)"
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

    if ($UseGit) {
        Write-Step "Cloning repository with git..."
        git clone --depth 1 $REPO_URL $TempDir 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  ✖ git clone failed, falling back to ZIP download..." -ForegroundColor Red
            $UseGit = $false
        } else {
            Write-Success "Repository cloned."
        }
    }

    if (-Not $UseGit) {
        Write-Step "Downloading repository as ZIP..."
        $ZipPath = Join-Path $env:TEMP "superpowers-$(Get-Random).zip"
        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $REPO_ZIP -OutFile $ZipPath -UseBasicParsing
            Write-Step "Extracting ZIP..."
            Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
            # GitHub ZIP extracts to a subfolder like "superpowers-main/"
            $ExtractedFolder = Get-ChildItem -Path $TempDir -Directory | Select-Object -First 1
            if ($ExtractedFolder) {
                $TempDir = $ExtractedFolder.FullName
            }
            Remove-Item $ZipPath -Force -ErrorAction SilentlyContinue
            Write-Success "Download complete."
        } catch {
            Write-Host "  ✖ Download failed: $_" -ForegroundColor Red
            Write-Host "  Please clone manually: git clone $REPO_URL" -ForegroundColor Red
            exit 1
        }
    }

    $SourceSkillsDir    = Join-Path $TempDir "skills"
    $SourceWorkflowsDir = Join-Path $TempDir "global_workflows"
} else {
    # ─────────────────────────────────────────
    #  LOCAL MODE: Running from cloned directory
    # ─────────────────────────────────────────
    Write-Info "Local install mode (running from: $PSScriptRoot)"
    $SourceSkillsDir    = Join-Path $PSScriptRoot "skills"
    $SourceWorkflowsDir = Join-Path $PSScriptRoot "global_workflows"
    $TempDir = $null
}

# ─────────────────────────────────────────────
#  Install skills
# ─────────────────────────────────────────────
Write-Host ""
Write-Step "Installing skills to: $SkillsDir"
Ensure-Dir $SkillsDir

if (Test-Path $SourceSkillsDir) {
    Copy-Item -Path "$SourceSkillsDir\*" -Destination $SkillsDir -Recurse -Force
    Write-Success "Skills installed."
} else {
    Write-Host "  ✖ Skills directory not found at: $SourceSkillsDir" -ForegroundColor Red
    exit 1
}

# ─────────────────────────────────────────────
#  Install global_workflows (if present)
# ─────────────────────────────────────────────
if (Test-Path $SourceWorkflowsDir) {
    Write-Step "Installing global workflows to: $WorkflowsDir"
    Ensure-Dir $WorkflowsDir
    Copy-Item -Path "$SourceWorkflowsDir\*" -Destination $WorkflowsDir -Recurse -Force
    Write-Success "Global workflows installed."
} else {
    Write-Info "No global_workflows directory found — skipping."
}

# ─────────────────────────────────────────────
#  Cleanup temp dir (remote mode only)
# ─────────────────────────────────────────────
if ($TempDir -and (Test-Path $TempDir)) {
    Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
}

# ─────────────────────────────────────────────
#  Done
# ─────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║  ✅  Installation complete!                   ║" -ForegroundColor Green
Write-Host "  ║                                               ║" -ForegroundColor Green
Write-Host "  ║  Skills  → $SkillsDir" -ForegroundColor Green
Write-Host "  ║                                               ║" -ForegroundColor Green
Write-Host "  ║  Antigravity will load these skills auto.     ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
