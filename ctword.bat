:: type "ctword" and the name of the word file you want to create

@echo off

setlocal

:: Check if filename/path argument was provided
	if "%~1"=="" (
    		echo Usage: ctword filename_or_path
    		exit /b 1
	)
:: "if condition ()" → the if conditional block syntax
:: %1 → This is the first argument passed to the batch file. It reads 'argument 1'
:: ~ (tilde modifier) → strip surrounding quotes if they exist
:: "%~1" → Surrounding quotes prevents errors if %1 is empty or contains spaces
:: exit /b 1 tells the script to exit the batch scrippt with error status 1

	set "filepath=%~1"
:: set is the keyword to create a variable
:: variables are created with not spaces on either side of the assignment operator (=)
:: the entire variable declaration is enclosed in "" to prevent trailing spaces from ...
:: ... being included in the variable
:: so "filepath=%~1" reads 'store argument 1 without any trailing spaces in the container "filepath"'

:: If no extension, add .docx
	if /i not "%~x1"==".docx" set "filepath=%filepath%.docx"
:: single line if statement does not require ().
:: /i → case insensitive
:: not → condition meaning if what follows is not true
:: % → argument, ~ → strip surrounding quoted from the targeted argumment, 
:: x → extension, looks for a '.' and targets what comes after it
:: 1 → the first argument provide e.g ctword myFile, myFile is the first argument
:: %filepath% → the variable created in the script, as the variable 'filepath' is ...
:: ... created within the script standard syntax to reference it is %var_name%
:: The two % are delimiters that tell cmd.exe to expand the variable before running the command.
:: set "filepath=%~1" creates a variable named filepath. Later, writing "%filepath%" tells the parser: ...
:: ... replace this with the current value of filepath and keep the quotes around the result ...
:: ... so paths with spaces don’t break.

:: If file does not exist, create it
	if not exist "%filepath%" type nul > "%filepath%"
:: Creates an empty file in memory named with the string stored in the variable ==> type nul > "ESI_Form.docx"

:: Open it in Word
	start "" winword "%filepath%"
:: start → Runs a program in a new window (or detached from the batch).
:: the first argument given to the star command is considered as the window title name ...
:: so the "" after start tells the start command to start an application without a title name ... 
:: ... the window title name argument cannot be ommitted so "" is used as as placeholder 

:: opens/starts word application   ==> start winword "ESI_Form.docx"

endlocal

