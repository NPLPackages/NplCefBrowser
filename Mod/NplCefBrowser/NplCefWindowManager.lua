--[[
Title: NplCefWindowManager
Author(s): leio
Date: 2016.12.29
Desc: 
NplCefWindowManager manager all of cef windows. It include below important compoments:
1 NplCefBrowserManager:manage npl communication with cef's dll, only one direction which npl call cef's dll is valid,
					   npl don't receive a callback from cef's dll. a unique id is important for communication. this id's value is the same as cef window's name.
					   cef's dll source:https://github.com/tatfook/NplCefBrowserDev
2 pe_cefbrowser:a mcml tag which inlucde a cef window.
3 pe_resizeable:a mcml tag which can resize cef window.
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/NplCefWindowManager.lua");
local NplCefWindowManager = commonlib.gettable("Mod.NplCefWindowManager");
NplCefWindowManager:Open();
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/Window.lua");
local Window = commonlib.gettable("System.Windows.Window");
local NplCefWindowManager = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.NplCefWindowManager"));

NplCefWindowManager.page_ctrls = {};
NplCefWindowManager.config = {};
NplCefWindowManager.withControl = true;
NplCefWindowManager.width = 800;
NplCefWindowManager.height = 560;
-- Default window's name.
NplCefWindowManager.default_window_name = "NplCefWindow_Instance";
-- NOTE:self.cefbrowser_name is a unique name in pe_cefbrowser_template.html. 
-- if you use a custom mcml page instead of "pe_cefbrowser_template.html", please remain this attribute on the mcml node of pe:cefbrowser.
NplCefWindowManager.cefbrowser_name = "cefbrowser_instance";
-- Default window's rendering page. you can use a custom mcml page instead of this page.
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
-- Create or open a cef window.
-- @param name:a unique window's name, default value is "NplCefWindow_Instance".
-- @param title:window's title.
-- @param url:a web address which will be opened by cef window.
-- @param alignment:window's alignment,default value is "_ct" which means center top alignment. "_lt" may be a common choice, it means left top alignment.
-- @param x:window's x coordinates. the original point locate at left top corner.
-- @param x:window's y coordinates. the original point locate at left top corner.
-- @param width:window's width.
-- @param height:window's height.
-- @param window_template_url:a mcml page which rendering the style of cef window, default value is "Mod/NplCefBrowser/pe_cefbrowser_template.html"
-- @param zorder:the show level of Window,default value is 10001.
function NplCefWindowManager:Open(name, title, url, alignment, x, y, width, height, window_template_url, zorder)
	name = name or self.default_window_name;
	zorder = zorder or 10001;
	if(self:GetPageCtrl(name))then
		self:Show(name,true);
	else
		title = title or "";
		alignment = alignment or "_ct";
		width = width or self.width;
		height = height or self.height

		x = x or -width/2;
		y = y or -height/2;
		
		window_template_url = window_template_url or self.default_template_url;
		self.config[name] = {
			title = title,
		}
		local window = Window:new();
		window:Show({
			name = name,
			url = window_template_url, 
			alignment = alignment, left = x, top = y, width = width, height = height,
			allowDrag = true, 
			zorder = zorder,
		});
		NPL.load("(gl)script/ide/timer.lua");
		local mytimer = commonlib.Timer:new({callbackFunc = function(timer)
			self:Reload(name,url);
		end})
		mytimer:Change(500)
		
	end
end
-- Show or hide a cef window.
-- @param name:window's unique name. default value is "NplCefWindow_Instance".
-- @param bShow:a bool value, True show window, otherwise hide window.
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
-- Destroy a cef window.
-- @param name:window's unique name. default value is "NplCefWindow_Instance".
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
-- Enbale or disable a cef window.
-- @param name:window's unique name. default value is "NplCefWindow_Instance".
-- @param enabled:a bool value, True enable window, otherwise disable.
function NplCefWindowManager:EnableWindow(name,enabled)
	name = name or self.default_window_name;
	local page_ctrl = self:GetPageCtrl(name);
	if(page_ctrl)then
		local window = page_ctrl:GetWindow();
		local cefbrowser_node = self:GetCefBrowserNode(name);
		cefbrowser_node:EnableWindow(enabled);
	end
end
-- Reload a web address.
-- @param name:window's unique name. default value is "NplCefWindow_Instance".
-- @param url:a web address which will be reloaded by cef window.
function NplCefWindowManager:Reload(name,url)
	name = name or self.default_window_name;
	local page_ctrl = self:GetPageCtrl(name);
	if(page_ctrl)then
		local cefbrowser_node = self:GetCefBrowserNode(name);
		cefbrowser_node:Reload(url);
	end
end
-- Through PageCtrl get the cefbrowser_node by window's name.
-- NOTE:self.cefbrowser_name is a unique name in pe_cefbrowser_template.html. 
-- if you use a custom mcml page instead of "pe_cefbrowser_template.html", please remain this attribute on the mcml node of pe:cefbrowser.
-- @param name:window's unique name.
function NplCefWindowManager:GetCefBrowserNode(name)
	local page_ctrl = self:GetPageCtrl(name);
	local cefbrowser_node = page_ctrl:GetNode(self.cefbrowser_name);
	return cefbrowser_node;
end

