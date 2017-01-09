# NplCefBrowser
NplCefBrowser is a npl package which include a wrapper for Chromium Embedded Framework 3(cef),After installed this package, Npl could create cef3 browser.
### Main classes
- NplCefBrowserManager:manage npl communication with cef's dll, only one direction which npl call cef's dll is valid,
					   npl don't receive a callback from cef's dll. a unique id is important for communication. this id's value is same as cef window's name.
					   [cef's dll source is here](https://github.com/tatfook/NplCefBrowserDev)
- pe_cefbrowser:a mcml tag which inlucde a cef window.
- pe_resizeable:a mcml tag which can resize cef window.
### Example
```lua
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");
NplCefWindowManager:Open(); -- Open a default window
```
```lua
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");
NplCefWindowManager:Open("my_window", "Npl window", "http://www.nplproject.com/", "_lt", 100, 100, 800, 560); -- Open a new window
```
### Screenshot
![image](https://cloud.githubusercontent.com/assets/5885941/21758468/168ddc44-d677-11e6-865f-412783282bae.png)

