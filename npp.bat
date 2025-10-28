@echo off

set "file=%~1"

:: If no argument is passed, just open notepad++

if "%file%"=="" (
	start "" "C:\Program Files\Notepad++\notepad++.exe"
	exit /b
)

:: If the file doesn't exist, create it silently
if not exist "%file%" type nul > "%file%"


start "" /D "%CD%" "C:\Program Files\Notepad++\notepad++.exe" "%file%"

