@echo off
setlocal enabledelayedexpansion
if "%~1"=="" (
	echo Usage: %~nx0 number_of_files
	exit /b 1
)
set "COUNT=%~1"
set "DOWNLOADS=%USERPROFILE%\Downloads"
set "TARGET=%DOWNLOADS%\Pictures"
set "OUTFOLDER=%DOWNLOADS%\Pictures_out"

for /f %%C in ('dir /b /a:-d "%DOWNLOADS%\*.jpg" "%DOWNLOADS%\*.jpeg" "%DOWNLOADS%\*.png" 2^>nul ^| find /c /v ""') do set "FILECOUNT=%%C"
echo Found %FILECOUNT% image files in "%DOWNLOADS%".

REM 	for /f %%C in (' ... ') do ...
:: for /f runs a command enclosed in '...', reads its output line by line, and assigns each line’s text to a variable — here %%C.

REM 	dir /b
:: /b = “bare format” → list only filenames, no details.

REM 	/a:-d
:: This means: show all non-directory items (i.e., files only).
:: So we don’t list any subfolders inside Downloads.

REM 	"*.jpg" "*.jpeg" "*.png"
:: This tells dir to list all matching files with those extensions.
:: If none exist, dir would normally print an error message — but…

REM 	2^>nul
:: The 2> redirects stderr (error output) to nul, meaning “discard error messages.”
:: The ^ is needed to escape the > because it’s inside a for /f command — otherwise, the > would be parsed too early.
:: So effectively:
:: → ignore “File Not Found” messages if no images exist.

REM 	^|
:: That’s an escaped pipe symbol. The caret (^) prevents premature parsing, same reason as above.
:: So now we’re piping the output of dir into another command — find.

REM 	find /c /v ""
:: This is a clever counting trick.
:: /c tells find to output the number of matching lines, not the lines themselves.
:: /v "" means: match all lines that do not contain the empty string.
:: Since every line “does not contain” an empty string (in find logic), every line is counted.

:: Result: it outputs only one line — the total number of lines (i.e., files).

REM 	do set "FILECOUNT=%%C"

:: Finally, the for /f reads that single output line (the count), assigns it to %%C, and stores it in the variable FILECOUNT.


if %FILECOUNT% lss %COUNT% (
    echo Not enough image files. Requested %COUNT%, but only found %FILECOUNT%.
    exit /b 1
)


if exist "%TARGET%" (
	echo Deleting existing images in Pictures\ ...
	del /q "%TARGET%\*" >nul 2>&1
) else (
	mkdir "%TARGET%"
)
if exist "%OUTFOLDER%" (
	echo Deleting existing images in Pictures_out\ ...
	del /q "%OUTFOLDER%\*" >nul 2>&1
) else (
	mkdir "%OUTFOLDER%"
)

set /a CNT=0
set "MOVEFAIL=0"
for /f "delims=" %%A in ('
	dir /b /a:-d /o:-d "%DOWNLOADS%"
') do (
	set /a CNT+=1
	if !CNT! leq %COUNT% (
		set "EXT=%%~xA"
		move "%DOWNLOADS%\%%A" "%TARGET%\Pic!CNT!!EXT!" >nul
        if errorlevel 1 set "MOVEFAIL=1"
	)
)

if %MOVEFAIL% neq 0 (
    echo One or more files could not be moved. Aborting...
	pause
    exit /b 1
)

if errorlevel 1 (
    echo An error occurred during file processing. Aborting...
	pause
    exit /b 1
)

:: Ensure all files are fully written/moved before processing
timeout /t 1 >nul

cmd /c exit 0

echo Launching GIMP process...

for /f "delims=" %%G in ('dir /s /b "C:\*gimp-console-3.*.exe" 2^>nul ^| findstr /i "bin"') do set "GIMP_EXE=%%G"

if not defined GIMP_EXE (
    echo GIMP console not found on drive C:. Aborting.
	pause
    exit /b 1
)
echo GIMP found at: %GIMP_EXE%

cmd /c exit 0

set "GIMPSCRIPTCALL=file = Gio.File.new_for_path(r'C:\Users\S10DIGITAL\Downloads\Pictures\Pic1.jpeg'); img = Gimp.file_load(Gimp.RunMode.NONINTERACTIVE, file); proc = Gimp.get_pdb(); mypross = proc.lookup_procedure('sk-plug-in-css-con-gui-python'); config = mypross.create_config(); config.set_property('run-mode', Gimp.RunMode.NONINTERACTIVE); config.set_property('image', img); mypross.run(config)"

call "%GIMP_EXE%" -i --batch-interpreter=python-fu-eval -b "%GIMPSCRIPTCALL%" --quit

:: the 'call' keyword ensures that control is passed back to the batch script after execution

if !errorlevel! equ 0 (
    echo GIMP batch executed successfully. Running Word automation...
) else (
    echo GIMP process failed with exit code %errorlevel%.
	pause
)

cmd /c exit 0

"%~dp0wt2word.bat"

if !errorlevel! neq 0 (
	echo wt2word.bat failed with exit code !errorlevel!.
	pause
) else (
	echo Word automation completed successfully.
)


:: %~dp0 --> "%~dp0wt2word.bat"
:: This is a special modifier that expands to:
:: 	%0 → the current batch file’s full path and name
:: 	~d → drive letter of %0
:: 	~p → path of %0 (excluding the filename)
:: So %~dp0 means:
:: 	“the drive and path of this batch file, ending with a backslash.”
:: If the current script is --> C:\myScripts\mainScript.bat
:: then %~dp0 becomes --> C:\myScripts\
:: That makes the full expression %~dp0wt2word.bat --> C:\myScripts\wt2word.bat

endlocal
