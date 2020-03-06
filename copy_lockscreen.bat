@echo off

Rem A batch file to copy Windows lock screen wallpaper to your Picture folder
Rem One way to check if it is a wallpaper and not a thumbnail is to check the file size 
Rem Other way is to check last modified date (the wallpaper will have newer date, within the last month)

setlocal enabledelayedexpansion
set "curPath=%~dp0"

:setDirectories
Rem go to the folder of wallpaper
set "wallpaperDir=%USERPROFILE%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
Rem get date to make unique folder name
for /F "tokens=2" %%G in ('echo %date%') do set dirName=%%G
Rem replace / with _
set dirName=%dirName:/=_%
set "targetPath=%USERPROFILE%\Pictures\wallpaper_%dirName%"
mkdir %targetPath%
if %ERRORLEVEL% equ 0 goto copyFiles

Rem folder exists
echo Attempting to erase its content.
choice /C yn /t 10 /d n /M "Would you like to continue?"
if %ERRORLEVEL% equ 2 goto doneCancelled
if %ERRORLEVEL% equ 1 goto deleteFiles

:deleteFiles
echo Deleting previous files...
cd %targetPath%
del /q *
cd %curPath%

:copyFiles
echo Copying files...
Rem copy the first 12 of the file sorted by modified date
set looperIndex=0
for /F %%A in ('dir %wallpaperDir% /B /O:-S') do (
	REM echo %%A
	robocopy %wallpaperDir% %targetPath% %%A > nul
	set /a looperIndex += 1
	REM echo !looperIndex!
	if !looperIndex! equ 12 goto renameFiles
)

:renameFiles
Rem rename format to something readable
cd /d %targetPath%
ren * *.jpg
echo Wallpapers are in %targetPath%
cd /d %curPath%
goto done

:doneCancelled
echo Operation cancelled.

:done