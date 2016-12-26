--[[
Title: NplCefBrowser
Author(s): leio
Date: 2016.11.24
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/main.lua");
local NplCefBrowser = commonlib.gettable("Mod.NplCefBrowser");
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
	local root = ParaIO.GetCurDirectory(0);
	LOG.std(nil, "info", "NplCefBrowser root", root);

	NplCefBrowserManager:Init();
	if(NplCefBrowserManager:HasCefPlugin())then
		NplCefBrowserManager:Start();
	end
	self:RegisterCommand();
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
function NplCefBrowser:RegisterCommand()
	local Commands = commonlib.gettable("MyCompany.Aries.Game.Commands");
	Commands["nplbrowser"] = {
		name="nplbrowser", 
		quick_ref="/nplbrowser", 
		desc="open a web browser", 
		handler = function(cmd_name, cmd_text, cmd_params, fromEntity)
		end,
	};
end

