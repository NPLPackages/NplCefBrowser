--[[
Title: NplCefBrowserManager
Author(s): leio
Date: 2016.11.24
Desc: 
Manage npl communication with cef's dll, only one direction which npl call cef's dll is valid,
npl don't receive a callback from cef's dll. a unique id is important for communication. this id's value is the same as cef window's name.
cef's dll source:https://github.com/tatfook/NplCefBrowserDev
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
------------------------------------------------------------
]]
local NplCefBrowserManager = commonlib.inherit(commonlib.gettable("Mod.ModBase"),commonlib.gettable("Mod.NplCefBrowserManager"));

-- Read a version from a txt file. internal format like this:ver=284
-- Return a number value.
function NplCefBrowserManager:GetVersionValue(version_txt_path)
	if(not version_txt_path)then return 0 end
	local file = ParaIO.open(version_txt_path, "r");
	if(file:IsValid())then
		--format:
		local line = file:readline();
		if(line)then
			local value = string.match(line,"%s-ver%s-=%s-(%d)%s-");
			value = tonumber(value);
			return value;
		end
		file:close();
	end
	return 0;
end
-- Read old version
function NplCefBrowserManager:ReadOldVersion()
	local version_value = -1;
	local old_version_txt_path = self.cefroot .. "/version.txt";
	old_version_txt_path = ParaIO.GetCurDirectory(0) .. old_version_txt_path;
	if(ParaIO.DoesFileExist(old_version_txt_path))then
		version_value = self:GetVersionValue(old_version_txt_path);
	end
	return version_value;

end
-- Read new version from zip file.
function NplCefBrowserManager:ReadNewVersionFromZipFile(zip_filename)
	local version_value = -1;

	if(ParaIO.DoesAssetFileExist(zip_filename, true))then
		ParaAsset.OpenArchive(zip_filename);	
		version_value = self:GetVersionValue("NplCef3/Mod/NplCef3/cef3/version.txt");
		ParaAsset.CloseArchive(zip_filename);
	end
	return version_value;
end
-- CheckVersion and unzip cef's dll so that npl could communicate with it.
function NplCefBrowserManager:CheckVersion()
	if(self:IsDebug())then
		LOG.std(nil, "info", "NplCefBrowserManager", "Debug mode ignored CheckVersion.");
		return
	end
	LOG.std(nil, "info", "NplCefBrowserManager", "UnzipCefDll");
	local filename = "Mod/NplCef3.zip";
	local cef3_root = "nplcef3/mod/";
	if(ParaIO.DoesAssetFileExist(filename, true))then
		local new_version = self:ReadNewVersionFromZipFile(filename);
		local old_version = self:ReadOldVersion();
		LOG.std(nil, "info", "NplCefBrowserManager", "Check version:old_version = %d, new_version = %d",old_version,new_version);
		if(old_version >= new_version)then
			LOG.std(nil, "info", "NplCefBrowserManager", "Cefdll version is latest.");
			return;
		end
		--Delete old cef3.
		ParaIO.DeleteFile("Mod/NplCef3/Mod/NplCef3");
		LOG.std(nil, "info", "NplCefBrowserManager", "ParaAsset.OpenArchive:%s",filename);
		ParaAsset.OpenArchive(filename);	
		LOG.std(nil, "info", "NplCefBrowserManager", "search root:%s",cef3_root);
		local output = commonlib.Files.SearchFiles({}, cef3_root, {":.*dll", ":.*bin", ":.*exe", ":.*pak", ":.*dat", ":.*txt"}, 10, 10000, true, nil, filename);
		LOG.std(nil, "info", "NplCefBrowserManager search result:", output);
		if(output and #output>0) then
			local k,v; 
			for k,v in ipairs(output) do
				local source_path = cef3_root .. v;
				local dest_path = "Mod/" .. source_path;
				local re = ParaIO.CopyFile(source_path, dest_path, true);
				LOG.std(nil, "info", "NplCefBrowserManager", "copy(%s) %s -> %s",tostring(re),source_path,dest_path);
			end
		end
		ParaAsset.CloseArchive(filename);
		
	end
end
function NplCefBrowserManager:IsDebug()
	local cefdebug = System.os.args("cefdebug", false)
	if(cefdebug == "true" or cefdebug == "True" )then
		return true;
	end
	return cefdebug;
end
-- Initialize cef plugin dll.
function NplCefBrowserManager:Init()
	self.mRootWindows = {};
	local cefroot = System.os.args("cefroot", "Mod/NplCef3/Mod/NplCef3/cef3")
	self.cefroot = cefroot;
	self.is_start = false;

	self.plugin_name = cefroot .. "/" .. System.os.args("cef_plugin", "NplCefPlugin.dll");
	self.process_name = cefroot .. "/" .. System.os.args("cef_process", "NplCefProcess.exe");
	
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
