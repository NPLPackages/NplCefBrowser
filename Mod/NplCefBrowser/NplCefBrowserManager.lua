--[[
Title: NplCefBrowserManager
Author(s): leio
Date: 2016.11.24
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/NplCefBrowserManager.lua");
local NplCefBrowserManager = commonlib.gettable("Mod.NplCefBrowserManager");
NplCefBrowserManager:Open(nil,"http://www.wikicraft.cn");
NplCefBrowserManager:Show(nil,false);
NplCefBrowserManager:ChangePosSize(nil,100,100,400,400);
NplCefBrowserManager:Delete(nil);
NplCefBrowserManager:NewWindow(nil,"http://www.wikicraft.cn");
NplCefBrowserManager:Quit();
------------------------------------------------------------
]]
local NplCefBrowserManager = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.NplCefBrowserManager"));

function NplCefBrowserManager:Init()
	self.mRootWindows = {};
	local cefroot = System.os.args("cefroot", "Mod/NplCefBrowser/cef3")
	local cefdebug = System.os.args("cefdebug", "false")
	LOG.std(nil, "info", "NplCefBrowserManager", "cefroot:%s", cefroot);
	self.cefroot = cefroot;
	self.is_start = false;
	if(cefdebug == "true" or cefdebug == "True" )then
		self.plugin_name = self.cefroot .. "/NplCefPlugin_d.dll";
		self.process_name = self.cefroot .. "/NplCefProcess_d.exe";
	else
		self.plugin_name = self.cefroot .. "/NplCefPlugin.dll";
		self.process_name = self.cefroot .. "/NplCefProcess.exe";
	end
	self.default_id = "cef_default_window";
end

function NplCefBrowserManager:HasCefPlugin()
	local root = ParaIO.GetCurDirectory(0);
	local process_path = root .. self:GetProcessName();
	local plugin_path = root .. self:GetPluginName();
	LOG.std(nil, "info", "NplCefBrowserManager", "process_path:%s", process_path);
	LOG.std(nil, "info", "NplCefBrowserManager", "plugin_path:%s", plugin_path);
	if(ParaIO.DoesFileExist(process_path) and ParaIO.DoesFileExist(plugin_path))then
		return true;
	end
end
function NplCefBrowserManager:Start()
	if(self.is_start)then
		return
	end	
	LOG.std(nil, "info", "NplCefBrowserManager", "Start");
	self.is_start = true;
	self:CreateOrOpen();
end
function NplCefBrowserManager:GetDefaultID()
	return self.default_id;
end
function NplCefBrowserManager:Open(id,url)
	id = id or self:GetDefaultID();
	LOG.std(nil, "info", "NplCefBrowserManager", "Open:%s %s",id,url);
	self:CreateOrOpen(id, url, false, false, true, false, nil, nil, nil, nil);
end
function NplCefBrowserManager:Show(id,visible)
	local name = self:GetPluginName();
	if(not name)then
		return
	end
	id = id or self:GetDefaultID();
	LOG.std(nil, "info", "NplCefBrowserManager", "Show:%s %s",id, tostring(visible));
	NPL.activate(name,{ cmd = "Show", 
						subProcessName = self:GetProcessName(),
						parentHandle = self:GetParentHandle(),
						id = id,
						visible = visible,
	});
end
function NplCefBrowserManager:ChangePosSize(id,x,y,width,height)
	id = id or self:GetDefaultID();
	local name = self:GetPluginName();
	if(not name)then
		return
	end
	LOG.std(nil, "info", "NplCefBrowserManager", "ChangePosSize:%s %d %d %d %d",id,x,y,width,height);
	NPL.activate(name,{ cmd = "ChangePosSize", 
						subProcessName = self:GetProcessName(),
						parentHandle = self:GetParentHandle(),
						id = id,
						x = x or 0,
						y = y or 0,
						width = width or 800,
						height = height or 600,
						visible = true,
	});
end
function NplCefBrowserManager:Delete(id)
	id = id or self:GetDefaultID();
	local name = self:GetPluginName();
	if(not name)then
		return
	end
	LOG.std(nil, "info", "NplCefBrowserManager", "Delete:%s",id);
	NPL.activate(name,{ cmd = "Delete", 
						subProcessName = self:GetProcessName(),
						parentHandle = self:GetParentHandle(),
						id = id,
	});
	self:DeleteRootWindow(id);
end
function NplCefBrowserManager:Quit()
	local name = self:GetPluginName();
	if(not name)then
		return
	end
	LOG.std(nil, "info", "NplCefBrowserManager", "Quit");
	NPL.activate(name,{ cmd = "Quit", 
						subProcessName = self:GetProcessName(),
						parentHandle = self:GetParentHandle(),
	});
	self.mRootWindows = {};
	self.is_start = false;
end
function NplCefBrowserManager:NewWindow(id,url,x,y,width,height)
	id = id or self:GetDefaultID();
	self:CreateOrOpen(id, url, false, false, true, true, x, y, width, height);
	LOG.std(nil, "info", "NplCefBrowserManager", "NewWindow:%s %s %d %d %d %d",id,url,x, y, width, height);
end
function NplCefBrowserManager:CreateOrOpen(id, url, showTitleBar, withControl, visible, resize, x, y, width, height)
	local name = self:GetPluginName();
	id = id or self:GetDefaultID();
	LOG.std(nil, "info", "NplCefBrowserManager", "Plugin:%s CreateOrOpen:%s %s",name,id,url);
	if(name)then
		NPL.activate(name,{ cmd = "CreateOrOpen", 
		subProcessName = self:GetProcessName(),
		parentHandle = self:GetParentHandle(),
		id = id,
		url = url,
		showTitleBar = showTitleBar,
		withControl = withControl,
		x = x or 0,
		y = y or 0,
		width = width or 800,
		height = height or 600,
		resize = resize, 
		visible = visible,
		}); 

		self:AddRootWindow(id);
	end
end
function NplCefBrowserManager:HasRootWindow(id)
	if(not id)then
		return
	end
	return self.mRootWindows[id];
end
function NplCefBrowserManager:AddRootWindow(id)
	if(not id)then
		return
	end
	self.mRootWindows[id] = true;
end
function NplCefBrowserManager:DeleteRootWindow(id)
	if(not id)then
		return
	end
	self.mRootWindows[id] = nil;
end
function NplCefBrowserManager:SetCefRoot(cefroot)
	self.cefroot = cefroot;
end
function NplCefBrowserManager:GetCefRoot()
	return self.cefroot;
end
function NplCefBrowserManager:GetPluginName()
	return self.plugin_name;
end
function NplCefBrowserManager:GetProcessName()
	return self.process_name;
end
function NplCefBrowserManager:GetParentHandle()
	return ParaEngine.GetAttributeObject():GetField("AppHWND", 0);
end