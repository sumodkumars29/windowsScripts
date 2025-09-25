@echo off

:: @ → suppresses the command itself from being printed in the console.
:: echo off → disables command echoing globally (so only output of commands, not the commands themselves, shows).
:: Together, @echo off keeps the output clean.

setlocal enabledelayedexpansion

:: setlocal → starts a local environment for variables. When the batch ends, any changes to environment variables are discarded.

:: enabledelayedexpansion → allows using !VAR! syntax to expand variables at runtime inside loops. Normally %VAR% is expanded before the loop starts, which can cause incorrect values inside for loops.

:: check if argument is provided
if "%~1"=="" (
	echo Usage: %~nx0 number_of_files
	exit /b 1
)

:: %~1 → the first argument passed to the batch file (1 is the position). ~ removes quotes if the argument has them.
:: =="" → checks if the argument is empty.
:: If empty, prints usage message:
	:: %~nx0 → the name and extension of the batch file itself (like preppics.bat).
	:: exit /b 1 → exits the batch file with code 1 (indicating an error).


set "COUNT=%~1"
set "DOWNLOADS=%USERPROFILE%\Downloads"
:: %USERPROFILE% → environment variable pointing to the current user’s home directory
set "TARGET=%DOWNLOADS%\Pictures"

:: if Pictures\ already exists, clear it out
if exist "%TARGET%" (
	echo Deleting existing images in Pictures\ ...
	del /q "%TARGET%\*" >nul 2>&1
) else (
	mkdir "%TARGET%"
)

:: if exist "path" → checks if a file or folder exists.
:: If the folder exists:
	:: del /q "%TARGET%\*" → deletes all files in the folder quietly (/q) without prompting.
	:: >nul 2>&1 → redirects output (>nul) and errors (2>&1) to nowhere — keeps console clean.
:: Else, mkdir "%TARGET%" → makes the folder.
:: Note: del deletes files only, not subfolders. Subfolders would need rmdir /s /q.


:: reset counter
set /a CNT=0
:: set /a → sets a variable using arithmetic.

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

:: for /f "delims=" %%A in (' command ') do (...)
	:: /f → reads output of a command line by line.
	:: delims= → prevents breaking the line on spaces or tabs (keeps full filenames).
	:: %%A → loop variable. In batch files, use double percent %%; in command line, it’s single %.
	:: (' dir ... ') → runs dir in a subshell and loops over each line of output.

:: dir /b /a:-d /o:-d "%DOWNLOADS%"
	:: /b → bare format (filename only, no header/footer).
	:: /a:-d → only files, exclude directories (-d).
	:: /o:-d → sort descending by date modified (newest first).

:: Inside loop:
	:: set /a CNT+=1 → increment counter.
	:: if !CNT! leq %COUNT% → only process if counter ≤ number of files requested.
	:: set "EXT=%%~xA" → extract the file extension of %%A (like .jpg).
	:: move "%DOWNLOADS%\%%A" "%TARGET%\Pic!CNT!!EXT!" → move and rename the file.
	:: >nul → suppress output.

:: build a list of all files
set FILELIST=
for %%F in ("%TARGET%\Pic*") do (
    set FILELIST=!FILELIST! "%%F"
)
:: Purpose: gather all moved files into a single variable for GIMP.
:: for %%F in ("pattern") do → loops over files matching pattern.
:: !FILELIST! "%%F" → appends each file, surrounded by quotes, to FILELIST.
:: FILELIST will look like "Pic1.jpg""Pic2.jpg""Pic3.jpeg""Pic4.png"

:: call your existing gimp.bat with all files at once
call gimp.bat !FILELIST!
:: call → executes another batch file without exiting the current one.
:: !FILELIST! → all files as arguments. This ensures one GIMP instance opens all files.

endlocal
:: Ends the setlocal block.
:: Any variable changes inside the batch are discarded, returning the environment to how it was before running the batch.