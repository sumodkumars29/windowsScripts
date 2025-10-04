@echo off

echo Closing all PDFs opened in Adobe Acrobat...

taskkill /IM Acrobat* /F >nul 2>&1

echo Done!