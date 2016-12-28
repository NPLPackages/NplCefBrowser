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
NPL.load("(gl)Mod/NplCefBrowser/NplCefBrowserManager.lua");
local NplCefBrowserManager = commonlib.gettable("Mod.NplCefBrowserManager");

NPL.load("(gl)script/ide/math/Point.lua");
local Point = commonlib.gettable("mathlib.Point");


NPL.load("(gl)script/ide/System/Windows/mcml/PageElement.lua");
local pe_cefbrowser = commonlib.inherit(commonlib.gettable("System.Windows.mcml.PageElement"), commonlib.gettable("System.Windows.mcml.Elements.pe_cefbrowser"));
pe_cefbrowser:Property({"class_name", "pe:cefbrowser"});
function pe_cefbrowser:OnAfterChildLayout(layout, left, top, right, bottom)
	local width = right-left;
	local height = bottom-top;
	

	local page_ctrl = self:GetPageCtrl();
	local w = page_ctrl:GetWindow();

	local screen_x, screen_y, screen_width, screen_height = w.native_ui_obj:GetAbsPosition();
	local id = self:GetInstanceName(w.name);

	local x = screen_x + left;
	local y = screen_y + top;

	commonlib.echo({x,y,width,height});
	local url = self:GetString("url");
	local withControl = self:GetBool("withControl");
	if(url)then
		if(NplCefBrowserManager:GetWindowConfig(id))then
			NplCefBrowserManager:ChangePosSize({id = id, x = x, y = y, width = width, height = height, });
		else
			NplCefBrowserManager:Open({id = id, url = url, withControl = withControl, x = x, y = y, width = width, height = height, });
		end
	end
end
