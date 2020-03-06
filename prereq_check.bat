@echo off

Rem A batch file to check if a certain software is installed, example here is checking Python
Rem Disclaimer: only tested in one computer (Windows 10) with this particular Python version (3.7)
Rem so it may not work on different computer with different registry or Python version.

set "minVersion=3.0"

:checkSoftwareRegistry
reg query HKEY_LOCAL_MACHINE\SOFTWARE\Python\PythonCore > nul
if %ERRORLEVEL% neq 0 goto promptInstall

:checkSoftwareVersion
for /F "tokens=5 delims=\ USEBACKQ" %%F in (`reg query HKEY_LOCAL_MACHINE\SOFTWARE\Python\PythonCore`) do (
	set var=%%F
)
REM echo %var%
if %var% LSS %minVersion% goto updateSoftware
echo Python with proper version is already installed.
goto done

:updateSoftware
echo The minimum version required is %minVersion%, please update your Python in https://www.python.org/downloads/
start "" https://www.python.org/downloads/
goto done

:promptInstall
echo Python not found, download through https://www.python.org/downloads/
start "" https://www.python.org/downloads/
goto done

:done

