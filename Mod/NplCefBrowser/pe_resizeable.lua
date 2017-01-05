--[[
Title: pe_resizeable
Author(s): leio
Date: 2017/1/5
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/pe_resizeable.lua");
Elements.pe_resizeable:RegisterAs("resizeable","pe:resizeable");
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/mcml/Elements/pe_div.lua");
NPL.load("(gl)Mod/NplCefBrowser/ResizeableControl.lua");
local ResizeableControl = commonlib.gettable("Mod.NplCefBrowser.ResizeableControl")

local pe_resizeable = commonlib.inherit(commonlib.gettable("System.Windows.mcml.Elements.pe_div"), commonlib.gettable("System.Windows.mcml.Elements.pe_resizeable"));

function pe_resizeable:ctor()
end

function pe_resizeable:LoadComponent(parentElem, parentLayout, style)
	local _this = ResizeableControl:new():init(parentElem);
	self:SetControl(_this);
	pe_resizeable._super.LoadComponent(self, _this, parentLayout, style);
	_this:ApplyCss(self:GetStyle());
end

function pe_resizeable:OnLoadComponentBeforeChild(parentElem, parentLayout, css)
end

function pe_resizeable:OnLoadComponentAfterChild(parentElem, parentLayout, css)
end

function pe_resizeable:OnBeforeChildLayout(layout)
	if(#self ~= 0) then
		local myLayout = layout:new();
		local css = self:GetStyle();
		local width, height = layout:GetPreferredSize();
		local padding_left, padding_top = css:padding_left(),css:padding_top();
		myLayout:reset(padding_left,padding_top,width+padding_left, height+padding_top);
		for childnode in self:next() do
			childnode:UpdateLayout(myLayout);
		end
		width, height = myLayout:GetUsedSize();
		width = width - padding_left;
		height = height - padding_top;
		layout:AddObject(width, height);
	end
	return true;
end

function pe_resizeable:OnAfterChildLayout(layout, left, top, right, bottom)
	if(self.control) then
		self.control:setGeometry(left, top, right-left, bottom-top);
		self.control:layoutTrackers();
	end
end