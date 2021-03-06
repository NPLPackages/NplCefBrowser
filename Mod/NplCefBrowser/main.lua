--[[
Title: NplCefBrowser
Author(s): leio
Date: 2016.11.24
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/main.lua");
local NplCefBrowser = commonlib.gettable("Mod.NplCefBrowser");
NplCefBrowser:init();
------------------------------------------------------------
]]
NPL.load("(gl)Mod/NplCefBrowser/NplCefBrowserManager.lua");
local NplCefBrowserManager = commonlib.gettable("Mod.NplCefBrowserManager");

local NplCefBrowser = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.NplCefBrowser"));

-- name of the generator
NplCefBrowser.generator_name = "NplCefBrowser";
NplCefBrowser.cef_root= "";
function NplCefBrowser:ctor()
	
end

-- virtual function get mod name

function NplCefBrowser:GetName()
	return "NplCefBrowser"
end

-- virtual function get mod description 

function NplCefBrowser:GetDesc()
	return "NplCefBrowser is a plugin in paracraft"
end

function NplCefBrowser:init()
	LOG.std(nil, "info", "NplCefBrowser", "plugin initialized");
	

	NPL.load("(gl)Mod/NplCefBrowser/pe_resizeable.lua");
	local Elements = commonlib.gettable("System.Windows.mcml.Elements");
	Elements.pe_resizeable:RegisterAs("resizeable","pe:resizeable");

	NPL.load("(gl)Mod/NplCefBrowser/pe_cefbrowser.lua");
	Elements.pe_cefbrowser:RegisterAs("cefbrowser","pe:cefbrowser");

	NplCefBrowserManager:Init();
	--first unzip cef3 dll
	NplCefBrowserManager:CheckVersion()
	-- if( NplCefBrowserManager:HasCefPlugin())then
	-- 	-- TODO: delayed Loading will crash the app, I do not know why. 
	-- 	NplCefBrowserManager:CheckLoadPlugin();
	-- else
	-- 	LOG.std(nil, "warning", "Can't find NplCefBrowser dll");
	-- end
end
function NplCefBrowser:OnLogin()
end
-- called when a new world is loaded. 

function NplCefBrowser:OnWorldLoad()
end
-- called when a world is unloaded. 

function NplCefBrowser:OnLeaveWorld()
end

function NplCefBrowser:OnDestroy()
end


