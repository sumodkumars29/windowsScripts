@echo off

setlocal enabledelayedexpansion

:: check if argument is provided
if "%~1"=="" (
	echo Usage: %~nx0 number_of_files
	exit /b 1
)

set "COUNT=%~1"
set "DOWNLOADS=%USERPROFILE%\Downloads"
set "TARGET=%DOWNLOADS%\Pictures"

:: if Pictures\ already exists, clear it out
if exist "%TARGET%" (
	echo Deleting existing images in Picture\ ...
	del /q "%TARGET%\*" >nul 2>&1
) else (
	mkdir "%TARGET%"
)

:: reset counter
set /a CNT=0

:: newest files first, only files (no dirs)
for /f "delims=" %%A in ('
	dir /b /a:-d /o:-d "%DOWNLOADS%"
') do (
	set /a CNT+=1
	if !CNT! leq %COUNT% (
		set "EXT=%%~xA"
		move "%DOWNLOADS%\%%A" "%TARGET%\Pic!CNT!!EXT!" >nul
	)
)

:: build a list of all files
set FILELIST=
for %%F in ("%TARGET%\Pic*") do (
    set FILELIST=!FILELIST! "%%F"
)

:: call your existing gimp.bat with all files at once
call gimp.bat !FILELIST!

endlocal