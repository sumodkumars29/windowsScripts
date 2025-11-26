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

if %FILECOUNT% lss %COUNT% (
    echo Not enough image files. Requested %COUNT%, but only found %FILECOUNT%.
    exit /b 1
)

if exist "%TARGET%" (
	echo Deleting existing images in Pictures\ ...
	del /q "%TARGET%\*.jpg" "%TARGET%\*.jpeg" "%TARGET%\*.png" >nul 2>&1
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
set "FIRSTEXT="
for /f "delims=" %%A in ('
	dir /b /a:-d /o:-d "%DOWNLOADS%"
') do (
	set /a CNT+=1
	if !CNT! leq %COUNT% (
		set "EXT=%%~xA"
		move "%DOWNLOADS%\%%A" "%TARGET%\Pic!CNT!!EXT!" >nul
		if !CNT! equ 1 set "FIRSTEXT=!EXT!"
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

:: for /f "delims=" %%G in ('dir /s /b "C:\*gimp-console-3.*.exe" 2^>nul ^| findstr /i "bin"') do set "GIMP_EXE=%%G"

:: if not defined GIMP_EXE (
::     echo GIMP console not found on drive C:. Aborting.
:: 	pause
::     exit /b 1
:: )
:: echo GIMP found at: %GIMP_EXE%

:: cmd /c exit 0
set "GIMP_EXE=C:\Users\S10DIGITAL\AppData\Local\Programs\GIMP 3\bin\gimp-console-3.0.exe"
set "GIMPSCRIPTCALL=file = Gio.File.new_for_path(r'C:\Users\S10DIGITAL\Downloads\Pictures\Pic1%FIRSTEXT%'); img = Gimp.file_load(Gimp.RunMode.NONINTERACTIVE, file); proc = Gimp.get_pdb(); mypross = proc.lookup_procedure('sk-plug-in-css-con-gui-python'); config = mypross.create_config(); config.set_property('run-mode', Gimp.RunMode.NONINTERACTIVE); config.set_property('image', img); mypross.run(config)"

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

endlocal
