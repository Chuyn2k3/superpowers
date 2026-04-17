@echo off
setlocal
echo ==============================================
echo Installing Antigravity Superpower Skills...
echo ==============================================

set "SKILLS_DIR=%USERPROFILE%\.gemini\antigravity\skills"

if not exist "%SKILLS_DIR%" (
    echo Creating Antigravity skills directory at %SKILLS_DIR%...
    mkdir "%SKILLS_DIR%"
)

echo Copying skills...
xcopy "skills\*" "%SKILLS_DIR%\" /E /I /Y /H /C

if %ERRORLEVEL% equ 0 (
    echo.
    echo [SUCCESS] Skills have been installed to %SKILLS_DIR%
    echo Note: Antigravity will automatically load these skills.
) else (
    echo.
    echo [ERROR] Failed to copy skills.
)

pause
