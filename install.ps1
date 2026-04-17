$ErrorActionPreference = "Stop"
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "Installing Antigravity Superpower Skills..." -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

$SkillsDir = Join-Path $env:USERPROFILE ".gemini\antigravity\skills"

if (-Not (Test-Path -Path $SkillsDir)) {
    Write-Host "Creating Antigravity skills directory at $SkillsDir..."
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
}

$SourceDir = Join-Path $PSScriptRoot "skills"

Write-Host "Copying skills..."
Copy-Item -Path "$SourceDir\*" -Destination $SkillsDir -Recurse -Force

Write-Host "`n[SUCCESS] Skills have been installed to $SkillsDir" -ForegroundColor Green
Write-Host "Note: Antigravity will automatically load these skills." -ForegroundColor Green
