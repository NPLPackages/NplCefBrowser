--[[
Title: NplCefBrowserManager
Author(s): leio
Date: 2016.11.24
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/NplCefBrowserManager.lua");
local NplCefBrowserManager = commonlib.gettable("Mod.NplCefBrowserManager");
local id = nil;
NplCefBrowserManager:Open({id = id, url = "http://www.wikicraft.cn", withControl = true, x = 0, y = 0, width = 800, height = 600, });
NplCefBrowserManager:Show({id = id, visible = false});
NplCefBrowserManager:ChangePosSize({id = id, x = 100, y = 100, width = 400, height = 400, });
NplCefBrowserManager:Delete({id = id,});
NplCefBrowserManager:Quit();

NPL.load("(gl)Mod/NplCefBrowser/NplCefBrowserManager.lua");
local NplCefBrowserManager = commonlib.gettable("Mod.NplCefBrowserManager");
NplCefBrowserManager:UnzipCefDll();
------------------------------------------------------------
]]
local NplCefBrowserManager = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.NplCefBrowserManager"));

function NplCefBrowserManager:UnzipCefDll()
	LOG.std(nil, "info", "NplCefBrowserManager", "UnzipCefDll");
	local filename = "Mod/NplCefBrowser.zip";
	local cef3_root = "/cef3";
	if(ParaIO.DoesAssetFileExist(filename, true))then
		LOG.std(nil, "info", "NplCefBrowserManager", "ParaAsset.OpenArchive:%s",filename);
		ParaAsset.OpenArchive(filename);	
		local output = commonlib.Files.SearchFiles({}, cef3_root, {":.*dll", ":.*bin", ":.*exe", ":.*pak", ":.*dat"}, 10, 10000, true, nil, filename);
		commonlib.echo("============output");
		commonlib.echo(output);
		if(output and #output>0) then
			local k,v; 
			for k,v in ipairs(output) do
				local source_path = v;
				local dest_path = "Mod/" .. source_path;
				commonlib.echo({source_path, dest_path});
				ParaIO.CopyFile(source_path, dest_path, true);
			end
		end
		ParaAsset.CloseArchive(filename);
	end
end
function NplCefBrowserManager:Init()
	self.mRootWindows = {};
	local cefroot = System.os.args("cefroot", "Mod/NplCefBrowser/cef3")
	local cefdebug = System.os.args("cefdebug", "false")
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

	LOG.std(nil, "info", "NplCefBrowserManager", "===========================Init===========================");
	LOG.std(nil, "info", "NplCefBrowserManager", "cefroot:%s", cefroot);
	LOG.std(nil, "info", "NplCefBrowserManager", "process_name:%s", self.process_name);
	LOG.std(nil, "info", "NplCefBrowserManager", "plugin_name:%s", self.plugin_name);
end
function NplCefBrowserManager:CreateBrowserParams()
	local params = {
		cmd = nil,
		subProcessName = nil,
		parentHandle = nil,
		id = nil,
		url = nil,
		showTitleBar = false,
		withControl = false,
		x = 0,
		y = 0,
		width = 800,
		height = 600,
		visible = true,
		resize = true,
		enabled = true,
	}
	return params;
end
function NplCefBrowserManager:HasCefPlugin()
	local root = ParaIO.GetCurDirectory(0);
	local process_path = root .. self:GetProcessName();
	local plugin_path = root .. self:GetPluginName();
	if(ParaIO.DoesFileExist(process_path) and ParaIO.DoesFileExist(plugin_path))then
		return true;
	end
end
function NplCefBrowserManager:Start()
	if(self.is_start)then
		return
	end	
	self.is_start = true;
	local p = self:CreateBrowserParams();
	p.cmd= "Start";
	p.subProcessName = self:GetProcessName()
	p.parentHandle = self:GetParentHandle();
	NplCefBrowserManager:DoActivate(p);
end
function NplCefBrowserManager:Open(p)
	p = p or self:CreateBrowserParams();
	p.cmd= "Open";
	p.visible = true;
	p.id = p.id or self:GetDefaultID();
	self:MapWindowConfig(p.id,p)
	NplCefBrowserManager:DoActivate(p);
end
function NplCefBrowserManager:ChangePosSize(p)
	p = p or self:CreateBrowserParams();
	p.cmd= "ChangePosSize";
	p.id = p.id or self:GetDefaultID();
	p.resize = true;
	self:MapWindowConfig(p.id,p)
	NplCefBrowserManager:DoActivate(p);
end
function NplCefBrowserManager:Delete(p)
	p = p or self:CreateBrowserParams();
	p.cmd= "Delete";
	p.id = p.id or self:GetDefaultID();
	self:DeleteWindowConfig(p.id)
	NplCefBrowserManager:DoActivate(p);
end
function NplCefBrowserManager:Show(p)
	p = p or self:CreateBrowserParams();
	p.cmd= "Show";
	p.id = p.id or self:GetDefaultID();
	self:MapWindowConfig(p.id,p)
	NplCefBrowserManager:DoActivate(p);
end
function NplCefBrowserManager:EnableWindow(p)
	p = p or self:CreateBrowserParams();
	p.cmd= "EnableWindow";
	p.id = p.id or self:GetDefaultID();
	self:MapWindowConfig(p.id,p)
	NplCefBrowserManager:DoActivate(p);
end
function NplCefBrowserManager:Quit(p)
	p = p or self:CreateBrowserParams();
	p.cmd= "Quit";
	NplCefBrowserManager:DoActivate(p);

	self.mRootWindows = {};
	self.is_start = false;
end
function NplCefBrowserManager:DoActivate(value)
	local name = self:GetPluginName();
	if(not name)then
		LOG.std(nil, "error", "NplCefBrowserManager", "plugin name is nil.");
		return
	end
	LOG.std(nil, "info", "NplCefBrowserManager DoActivate", value);
	if(not value)then
		return
	end
	NPL.activate(name,value);
end
function NplCefBrowserManager:GetDefaultID()
	return self.default_id;
end
function NplCefBrowserManager:GetWindowConfig(id)
	if(not id)then
		return
	end
	return self.mRootWindows[id];
end
function NplCefBrowserManager:MapWindowConfig(id,value)
	if(not id)then
		return
	end
	self.mRootWindows[id] = value;
end
function NplCefBrowserManager:DeleteWindowConfig(id)
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
