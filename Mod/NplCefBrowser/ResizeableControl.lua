--[[
Title: ResizeableControl
Author(s): leio
Date: 2017/1/5
Desc: 
use the lib:
------------------------------------------------------------
NPL.load("(gl)Mod/NplCefBrowser/ResizeableControl.lua");
local ResizeableControl = commonlib.gettable("Mod.NplCefBrowser.ResizeableControl")

NPL.load("(gl)script/ide/System/Windows/Window.lua");
local Window = commonlib.gettable("System.Windows.Window")
local w = 400;
local h = 300;
local window = Window:new();
local root = ResizeableControl:new():init(window);
root:SetBackgroundColor("#000000");
root:setGeometry(0,0,w,h);
root:layoutTrackers();
window:Show("my_window", nil, "_lt", 0,0, w, h);
window:SetCanDrag(true);
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/UIElement.lua");
NPL.load("(gl)script/ide/System/Windows/Shapes/Rectangle.lua");
NPL.load("(gl)script/ide/timer.lua");
local UIElement = commonlib.gettable("System.Windows.UIElement")
local Rectangle = commonlib.gettable("System.Windows.Shapes.Rectangle");
local ResizeableControl = commonlib.inherit(commonlib.gettable("System.Windows.Shapes.Rectangle"),commonlib.gettable("Mod.NplCefBrowser.ResizeableControl"));
ResizeableControl:Property({"CanResize", false, auto=true});
ResizeableControl:Property({"TrackerSize", 5});

function ResizeableControl:ctor()
	self.trackers = {};
	self.dragging_index = nil;
	self.darg_info = {
		x = 0,
		y = 0,
		width = 0,
		height = 0,

		start_dragging_x = 0,
		start_dragging_y = 0,

		native_ui_x = 0,
		native_ui_y = 0,
		native_ui_width = 0,
		native_ui_height = 0,
	}
	local k;
	for k = 1,8 do
		local tracker = Rectangle:new():init(self);
		tracker:setGeometry(0,0,self.TrackerSize,self.TrackerSize);
		table.insert(self.trackers,tracker);

		tracker.handle_index = k;
		tracker.mousePressEvent = function(t, event)
			local index = t.handle_index;
			event:accept();
			local window = self:GetWindow();
			if(not window)then
				return
			end
			self.dragging_index = index;

			local x,y = ParaUI.GetMousePosition()
			
			local native_ui_x, native_ui_y, native_ui_width, native_ui_height = window.native_ui_obj:GetAbsPosition();

			self.darg_info.start_dragging_x = x;
			self.darg_info.start_dragging_y = y;

			self.darg_info.x = self:x();
			self.darg_info.y = self:y();
			self.darg_info.width = self:width();
			self.darg_info.height = self:height();

			self.darg_info.native_ui_x = native_ui_x;
			self.darg_info.native_ui_y = native_ui_y;
			self.darg_info.native_ui_width = native_ui_width;
			self.darg_info.native_ui_height = native_ui_height;

		end
		self.mouseReleaseEvent = function(t, event)
			self.dragging_index = nil;
		end
	end	

	self.timer = commonlib.Timer:new({callbackFunc = function(timer)
		local index = self.dragging_index;
		if(index)then
			local tracker = self.trackers[index];
			if(tracker)then
				local x,y = ParaUI.GetMousePosition()
				local dx = x - self.darg_info.start_dragging_x;
				local dy = y - self.darg_info.start_dragging_y;


				local old_x = self.darg_info.x;
				local old_y = self.darg_info.y;
				local width = self.darg_info.width;
				local height = self.darg_info.height;

				local native_ui_x = self.darg_info.native_ui_x;
				local native_ui_y = self.darg_info.native_ui_y;
				local native_ui_width = self.darg_info.native_ui_width;
				local native_ui_height = self.darg_info.native_ui_height;
				local window = self:GetWindow();

				if(not window)then
					return
				end

				local _x,_y,_width,_height;
				if(index == 1)then
					_x = dx + native_ui_x;
					_y = dy + native_ui_y;
					_width = width - dx;
					_height = height - dy;
				elseif(index == 2)then
					_x = native_ui_x;
					_y = dy + native_ui_y;
					_width = width;
					_height = height - dy;
				elseif(index == 3)then
					_x = native_ui_x;
					_y = dy + native_ui_y;
					_width = width + dx;
					_height = height - dy;
				elseif(index == 4)then
					_x = native_ui_x;
					_y = native_ui_y;
					_width = width + dx;
					_height = height;
				elseif(index == 5)then
					_x = native_ui_x;
					_y = native_ui_y;
					_width = width + dx;
					_height = height + dy;
				elseif(index == 6)then
					_x = native_ui_x;
					_y = native_ui_y;
					_width = width ;
					_height = height + dy;
				elseif(index == 7)then
					_x = dx + native_ui_x;
					_y = native_ui_y;
					_width = width - dx;
					_height = height + dy;
				elseif(index == 8)then
					_x = dx + native_ui_x;
					_y = native_ui_y;
					_width = width - dx;
					_height = height;
				end
				self:resize(_width,_height);
				self:layoutTrackers();
				window:setGeometry(_x,_y,_width,_height);
			end
		end
	end})
	self.timer:Change(0, 50)
end
function ResizeableControl:getHandle(n)
	local max_width = self:width();
	local max_height = self:height();
	local tracker_size = self.TrackerSize;
	local x,y,width,height;
	local center_width = max_width - 2 * tracker_size;
	local center_height = max_height - 2 * tracker_size;
	if(n == 1)then
		--top left
		x = 0;
		y = 0;
		width = tracker_size;
		height = tracker_size;
	elseif(n == 2)then
		--top center
		x = tracker_size;
		y = 0;
		width = center_width;
		height = tracker_size;
	elseif(n == 3)then
		--top right
		x = max_width - tracker_size;
		y = 0;
		width = tracker_size;
		height = tracker_size;
	elseif(n == 4)then
		--center right
		x = max_width - tracker_size;
		y = tracker_size;
		width = tracker_size;
		height = center_height;
	elseif(n == 5)then
		--bottom right
		x = max_width - tracker_size;
		y = max_height - tracker_size;
		width = tracker_size;
		height = tracker_size;
	elseif(n == 6)then
		--bottom center
		x = tracker_size;
		y = max_height - tracker_size;
		width = center_width;
		height = tracker_size;
	elseif(n == 7)then
		--bottom left
		x = 0;
		y = max_height - tracker_size;
		width = tracker_size;
		height = tracker_size;
	elseif(n == 8)then
		--center left
		x = 0;
		y = tracker_size;
		width = tracker_size;
		height = center_height;
	end
	return x,y,width,height
end
function ResizeableControl:layoutTrackers()
	local k,v;
	for k,v in ipairs(self.trackers) do
		local x,y,width,height = self:getHandle(k);
		v:setGeometry(x,y,width,height);
	end
end
function ResizeableControl:SetTrackerColor(style)
	if(not style)then return end
	local color = style["tracker-color"] or "#000000";
	local k,v;
	for k,v in ipairs(self.trackers) do
		v:SetBackgroundColor(color);
	end
end


