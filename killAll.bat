@echo off

echo Kill all open PDFs, IMAGEs and Explorer windows ...

call pdfkill
call pickill
call clsExp

echo Done!
