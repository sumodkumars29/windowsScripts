@echo off

echo Closing all IMAGESs opened in Photos.exe...

taskkill /IM Photo* /F >nul 2>&1

echo Done!