@echo off

echo starting gimp

call gimp.bat

echo Waiting for GIMP to fully load ...

:waitloop

::for /f "skip=3 tokens=2*" %%A in ('powershell -command "Get-Process gimp-3 | Select-Object MainWindowTitle"') do (
::	if "%%B"=="GNU Image Manipulation Program" goto loaded
::)

:: --- Check window title first ---
powershell -command "if ((Get-Process gimp-3 -ErrorAction SilentlyContinue).MainWindowTitle -eq 'GNU Image Manipulation Program') { exit 0 } else { exit 1 }"
if %ERRORLEVEL% neq 0 (
    timeout /t 2 >nul
    goto waitloop
)

:: --- If window title is correct, check if process is responding ---
powershell -command "if ((Get-Process gimp-3 -ErrorAction SilentlyContinue).Responding) { exit 0 } else { exit 1 }"
if %ERRORLEVEL% neq 0 (
    timeout /t 2 >nul
    goto waitloop
)

echo GIMP is ready!
