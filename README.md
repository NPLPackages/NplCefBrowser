# NplCefBrowser
NplCefBrowser is a npl package and paracraft mod which include a wrapper of Chromium Embedded Framework 3(cef). after installed this package, Npl could create cef3 browser.
### Main classes
- NplCefBrowserManager:manage npl communication with cef's dll, only one direction which npl call cef's dll is valid,
					   npl don't receive a callback from cef's dll. a unique id is important for communication. this id's value is same as cef window's name.
					   [cef's dll source is here](https://github.com/tatfook/NplCefBrowserDev)
- pe_cefbrowser:a mcml tag which inlucde a cef window.
- pe_resizeable:a mcml tag which can resize cef window.

### Install
- Download [NplCef3-0.1-beta](https://github.com/NPLPackages/NplCef3/releases/download/0.1-beta/NplCef3.zip) to /Mod.
- Download [NplCefBrowser-0.1-beta](https://github.com/NPLPackages/NplCefBrowser/releases/download/0.1-beta/NplCefBrowser.zip) to /Mod.
- Make NplCef3 valid
  - Start Paracraft and only enable the mod of NplCefBrowser, don't enable the mod of NplCef3.
  - If NplCefBrower isn't working, close paracraft and extract NplCef3.zip to /Mod directly. 
- After entered a world, use below example to test.
![image](https://cloud.githubusercontent.com/assets/5885941/22096783/6d7f80a0-de58-11e6-86f5-e4f03fb56518.png)

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

