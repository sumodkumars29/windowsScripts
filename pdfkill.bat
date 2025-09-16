@echo off

echo Closing all PDFs opened in Adobe Acrobar...

taskkill /IM Acrobat* /F >nul 2>&1

echo Done!