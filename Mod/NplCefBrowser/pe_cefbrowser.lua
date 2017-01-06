--[[
Title: pe_cefbrowser
Author(s): leio
Date: 2016/12/27
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/pe_cefbrowser.lua");
Elements.pe_cefbrowser:RegisterAs("cefbrowser","pe:cefbrowser");
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/mcml/Elements/pe_div.lua");
NPL.load("(gl)script/ide/System/Windows/MouseEvent.lua");
NPL.load("(gl)script/ide/math/Point.lua");
NPL.load("(gl)Mod/NplCefBrowser/NplCefBrowserManager.lua");
NPL.load("(gl)script/ide/System/Windows/mcml/PageElement.lua");

local Point = commonlib.gettable("mathlib.Point");
local MouseEvent = commonlib.gettable("System.Windows.MouseEvent");
local NplCefBrowserManager = commonlib.gettable("Mod.NplCefBrowserManager");


local pe_cefbrowser = commonlib.inherit(commonlib.gettable("System.Windows.mcml.PageElement"), commonlib.gettable("System.Windows.mcml.Elements.pe_cefbrowser"));
function pe_cefbrowser:OnAfterChildLayout(layout, left, top, right, bottom)
	local width = right-left;
	local height = bottom-top;
	local page_ctrl = self:GetPageCtrl();
	local id = self:GetID()
	local w = page_ctrl:GetWindow();
	local screen_x, screen_y, screen_width, screen_height = w.native_ui_obj:GetAbsPosition();


	local x = screen_x + left;
	local y = screen_y + top;

	local url = self:GetString("url");
	local withControl = self:GetBool("withControl");
	NplCefBrowserManager:Open({id = id, url = url, withControl = withControl, x = x, y = y, width = width, height = height, });
	CommonCtrl.AddControl(id, id);
	
	w.sizeEvent = function(o, event)
		local screen_x, screen_y, screen_width, screen_height = w.native_ui_obj:GetAbsPosition();
		local config = NplCefBrowserManager:GetWindowConfig(id);
		if(config)then
			local x = screen_x + left;
			local y = screen_y + top;
			local width = config.width;
			local height = config.height;
			NplCefBrowserManager:ChangePosSize({id = id, x = x, y = y, width = width, height = height, });
		end
	end
end
function pe_cefbrowser:GetID()
	local page_ctrl = self:GetPageCtrl();
	local id = self:GetInstanceName(page_ctrl.name);
	return id;
end
function pe_cefbrowser:Show(bShow)
	local id = self:GetID()
	local config = NplCefBrowserManager:GetWindowConfig(id);
	if(config)then
		config.visible = bShow;
		NplCefBrowserManager:Show(config);
	end
end
function pe_cefbrowser:EnableWindow(enabled)
	local id = self:GetID()
	local config = NplCefBrowserManager:GetWindowConfig(id);
	if(config)then
		config.enabled = enabled;
		NplCefBrowserManager:EnableWindow(config);
	end
end
function pe_cefbrowser:Destroy()
	local id = self:GetID()
	local config = NplCefBrowserManager:GetWindowConfig(id);
	if(config)then
		NplCefBrowserManager:Delete({id = id, });
	end
end
function pe_cefbrowser:Reload(url)
	local id = self:GetID()
	local config = NplCefBrowserManager:GetWindowConfig(id);
	if(config)then
		config.url = url;
		NplCefBrowserManager:Open(config);
	end
end
