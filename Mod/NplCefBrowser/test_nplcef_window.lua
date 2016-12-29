--[[
Title: test_nplcef_window
Author(s): leio
Date: 2016.12.29
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/test_nplcef_window.lua");
local test_nplcef_window = commonlib.gettable("Mod.test_nplcef_window");
test_nplcef_window.Open1();
test_nplcef_window.Open2();
test_nplcef_window.Open3();
test_nplcef_window.Reload3();
------------------------------------------------------------
]]
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");

local test_nplcef_window = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.test_nplcef_window"));

function test_nplcef_window.Open1()
	NplCefWindowManager:Open();
end
function test_nplcef_window.Open2()
	NplCefWindowManager:Open("test_2","Title", "www.wikicraft.cn");
end
function test_nplcef_window.Open3()
	NplCefWindowManager:Open("test_3","测试","www.wikicraft.cn", 200, 200);
end
function test_nplcef_window.Reload3()
	NplCefWindowManager:Reload("test_3","www.baidu.com");
end