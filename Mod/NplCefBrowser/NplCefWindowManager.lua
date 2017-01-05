--[[
Title: NplCefWindowManager
Author(s): leio
Date: 2016.12.29
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/Window.lua");
local Window = commonlib.gettable("System.Windows.Window");
local NplCefWindowManager = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.NplCefWindowManager"));

NplCefWindowManager.page_ctrls = {};
NplCefWindowManager.config = {};
NplCefWindowManager.withControl = true;
NplCefWindowManager.width = 1024;
NplCefWindowManager.height = 768;
NplCefWindowManager.default_window_name = "NplCefWindow_Instance";
NplCefWindowManager.cefbrowser_name = "cefbrowser_instance"; -- the same as pe_cefbrowser_template.html
NplCefWindowManager.default_template_url = "Mod/NplCefBrowser/pe_cefbrowser_template.html";
function NplCefWindowManager:AddPageCtrl(name,page_ctrl)
	self.page_ctrls[name] = page_ctrl;
end
function NplCefWindowManager:GetPageCtrl(name)
	return self.page_ctrls[name];
end
function NplCefWindowManager:GetConfig(name)
	return self.config[name];
end
function NplCefWindowManager:Open(name, title, url, x, y)
	name = name or self.default_window_name;
	if(self:GetPageCtrl(name))then
		self:Show(name,true);
	else
		x = x or 100;
		y = y or 100;
		self.config[name] = {
			title = title,
		}
		local window = Window:new();
		window:Show({
			name = name,
			url = self.default_template_url, 
			alignment ="_lt", left = x, top = y, width = self.width, height = self.height,
			allowDrag = true, 
		});
		NPL.load("(gl)script/ide/timer.lua");
		local mytimer = commonlib.Timer:new({callbackFunc = function(timer)
			self:Reload(name,url);
		end})
		mytimer:Change(500)
		
	end
end
function NplCefWindowManager:Show(name,bShow)
	name = name or self.default_window_name;
	local page_ctrl = self:GetPageCtrl(name);
	if(page_ctrl)then
		local window = page_ctrl:GetWindow();
		local cefbrowser_node = self:GetCefBrowserNode(name);

		if(bShow)then
			window:show();
		else
			page_ctrl:CloseWindow();
		end
		cefbrowser_node:Show(bShow);
	end
end
function NplCefWindowManager:EnableWindow(name,enabled)
	name = name or self.default_window_name;
	local page_ctrl = self:GetPageCtrl(name);
	if(page_ctrl)then
		local window = page_ctrl:GetWindow();
		local cefbrowser_node = self:GetCefBrowserNode(name);
		cefbrowser_node:EnableWindow(enabled);
	end
end
function NplCefWindowManager:Reload(name,url)
	name = name or self.default_window_name;
	local page_ctrl = self:GetPageCtrl(name);
	if(page_ctrl)then
		local cefbrowser_node = self:GetCefBrowserNode(name);
		cefbrowser_node:Reload(url);
	end
end
function NplCefWindowManager:GetCefBrowserNode(name)
	local page_ctrl = self:GetPageCtrl(name);
	local cefbrowser_node = page_ctrl:GetNode(self.cefbrowser_name);
	return cefbrowser_node;
end
function NplCefWindowManager:Destroy(name)
	name = name or self.default_window_name;
	local page_ctrl = self:GetPageCtrl(name);
	if(page_ctrl)then
		local cefbrowser_node = self:GetCefBrowserNode(name);
		cefbrowser_node:Destroy();
		page_ctrl:CloseWindow(true);

		self.page_ctrls[name] = nil;
		self.config[name] = nil;
	end
end
