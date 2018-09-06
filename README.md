# NplCefBrowser
NplCefBrowser is a npl package and paracraft mod which include a wrapper of Chromium Embedded Framework 3(cef). After installing this package, NPL could create cef3 browser via scripting interface.
### Main classes
- NplCefBrowserManager:manage npl communication with cef's dll, only one direction which npl call cef's dll is valid,
					   npl don't receive a callback from cef's dll. a unique id is important for communication. this id's value is same as cef window's name.
					   [cef's dll source is here](https://github.com/tatfook/NplCefBrowserDev)
- pe_cefbrowser:a mcml tag which inlucde a cef window.
- pe_resizeable:a mcml tag which can resize cef window.

### Build
Git clone with submodules. and run
```
build_without_update.bat
```
it will generate `NplCefBrowser.zip` file in root directory. 

### Install
Method1: One can do it via Mod GUI in paracraft. 
Method2: Manually copy `NplCefBrowser.zip` to `Mod/` folder. 

- In paracraft, one should see somehing like below:
![image](https://cloud.githubusercontent.com/assets/5885941/22096783/6d7f80a0-de58-11e6-86f5-e4f03fb56518.png)

> Please note, the first time the plugin is enabled or if a newer plugin is installed, it will automatically extract 30MB Chrome core executable files from the zip archive to a disk file folder at `Mod/NplCef3`. The folder has the same layout of the git submodule `https://github.com/NPLPackages/NplCef3`. This could take 3-10 seconds to complete, if one wants to avoid zipping on first use, one can manually deploy those chrome files. 

### Example
```lua
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");
NplCefWindowManager:Open(); -- Open a default window
```
```lua
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");
 -- Open a new window
NplCefWindowManager:Open("my_window", "Npl window", "http://www.nplproject.com/", "_lt", 100, 100, 800, 560);
--test1
```
### Screenshot
![image](https://cloud.githubusercontent.com/assets/5885941/21758468/168ddc44-d677-11e6-865f-412783282bae.png)

