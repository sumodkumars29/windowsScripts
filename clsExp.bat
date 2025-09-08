@echo off
:: This prevents showing the commands being run
:: Unlike >/dev/null 2>&1 in Linux, where all output is discarded,
:: the output from the commands in a batch file is still displayed.

powershell -command "$s=New-Object -ComObject Shell.Application; $s.Windows() | ForEach-Object { $_.Quit() }"

:: powershell → This tells CMD that what follows is to be executed in powershell
:: -command → This tells powershell what follows is the command to be executed
:: "....." everything inside the double quotes is the command passed to powershell
:: $s → variable, = → assignment operator
:: New-Object -ComObject Shell.Application → a new object that is a "Component Object Model" that conforms to the model of shell applications which is what it is given access to by the "Shell.Application"
:: Like vba such objects have properties and methods
:: $s.Windows() → calls the window property (any open window that is linked to a shell application)
:: $s.Windows() creates a list of all open windows accessible by the New-Object ($s) that has been defined as an object of Component Object Model with access to shell applications.
:: | → The result for the $s.Windows() is pushed into the command in the right
:: ForEach-Object → for loop looping through the list of open shell windows accessed
:: $_.Quit → the $_ is the current name in the loop, much like the i in
:: $_ represents the current object in the pipeline. 
:: dim i = range, for each i in range(A1:C1)
:: .Quit is a method built in for shell applications
:: In layman's terms :
:: Hi powershell, I hand this command over to you, just pass be the end result
:: Powershell : Okay, create a new object of component object model with access to shell applications and functions,
:: get a list of all open windows, loop through this list and close each window in the list.
:: once done let cmd know it was exit code 0

echo All File Explorer windows closed.
::Prints the text to the buffer