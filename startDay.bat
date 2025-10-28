::  This script will open both Chrome profiles with the given tabs and then launch Excel with your .xlsm file.

@echo off
:: Suppress command output
:: Launch Chrome with specific profiles and tabs

start "" chrome --profile-directory="Profile 1" https://www.gmail.com https://web.whatsapp.com
start "" chrome --profile-directory="Profile 2" https://web.whatsapp.com https://www.youtube.com

:: Launch Excel with the specified workbook
start "" excel "%USERPROFILE%\Desktop\Sales Tracker.xlsm"

:: start "" — the empty quotes set a blank window title (required when the command path or arguments are quoted).
::  --profile-directory="Profile 1" — correct syntax for Chrome profiles.
::  URLs prefixed with https:// are required (bare domains sometimes fail in .bat context).
::  @echo off ensures no command output.


