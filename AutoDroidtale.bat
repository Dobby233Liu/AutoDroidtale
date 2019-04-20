@echo off

color 2f

title AutoDroidtale

echo AutoDroidtale - another Batch Droidtale builder by LWYS
echo Requires JRE 8+
echo Thanks for: MrPowerGamerBR https://mrpowergamerbr.com/droidtale
echo and the Android Open Source Project https://source.android.com

pause
cls

set /p assetsdir=Please specify the assets directory (contains music and credits.txt): 
set /p datafile=Please specify the data.win file (will be renamed into game.droid): 
rem set /p toolsdir=Please specify the tools directory (contains aapt.exe and 7z.exe): 
set toolsdir="%~dp0\autodroidtale_tools"
rem set /p %wrapperfile%=Finally, the wrapper file: 
set wrapperfile="%toolsdir%\UndertaleStub.apk"
set /p outputapk=Output as: 

cls

title AutoDroidtale (working)

copy "%wrapperfile%" "%temp%\_runner.apk"
set tmprunner="%temp%\_runner.apk"

mkdir %temp%\assets
copy "%datafile%" "%temp%\assets\game.droid"
copy "%toolsdir%\splash.png" "%temp%\assets"
copy "%toolsdir%\portrait_splash.png" "%temp%\assets"

set tcd=%cd%
cd /d %temp%
%toolsdir%\7z d %tmprunner% assets/ -tzip -mx9
%toolsdir%\7z u %tmprunner% assets/ -tzip -mx9
cd /d %tcd%
rd /s /q %temp%\assets
rem pause
cls

forfiles /m *.txt /p %assetsdir% /c "cmd /c %toolsdir%\aapt add -f -v %tmprunner% @file"
forfiles /m *.ogg /p %assetsdir% /c "cmd /c %toolsdir%\aapt add -f -v %tmprunner% @file"
rem pause
cls

cmd /c %toolsdir%\apksigner sign -ks "%toolsdir%\keystore.jks" --ks-pass pass:123456 --key-pass pass:123456 %tmprunner%
move %tmprunner% %outputapk%

rem pause
cls

title AutoDroidtale
echo Done
pause