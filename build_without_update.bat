@echo off 
rem author: LiXizhi   date:2018.9.6

rem update and install packages from git

rem remove old redist folder
rmdir NplCefBrowser  /s /q
mkdir NplCefBrowser
rm  NplCefBrowser.zip
pushd "npl_packages"

CALL :BuddlePackage NplCef3

popd

rem copy files to NplCefBrowser folder for packaging
if exist Mod ( xcopy /s /y Mod  NplCefBrowser\Mod\ )
xcopy /y package.npl  NplCefBrowser\

call "7z.exe" a NplCefBrowser.zip NplCefBrowser\

EXIT /B %ERRORLEVEL%

:BuddlePackage
if exist "%1\Mod" (
    xcopy /s /y %1\Mod  ..\NplCefBrowser\npl_packages\%1\Mod\
) else (
    echo %1 is not a mod
)
EXIT /B 0