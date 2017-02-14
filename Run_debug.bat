
@echo off 
pushd "%~dp0../../redist/" 
rem @param world:default paracraft world for test application immediately,if this world is not exist,please create it first.
rem @param cefroot:the dll path of cef.
rem @param cefdebug:if true we will ignore check version.
rem @param cef_plugin:the name of cef plugin.
rem @param cef_process:the name of cef process.
call "ParaEngineClient.exe" mc="true" dev="%~dp0"  mod="NplCefBrowser" isDevEv="true" world="worlds/DesignHouse/test" cefroot="../_mod/NplCefBrowser/cef3" cefdebug="true" cef_plugin="NplCefPlugin.dll" cef_process="NplCefProcess.exe"
popd 