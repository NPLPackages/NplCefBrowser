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
	self.start_dragging_x = 0;
	self.start_dragging_y = 0;
	self.old_rect = {
		x = 0,
		y = 0,
		width = 0,
		height = 0,
	}
	local k;
	for k = 1,8 do
		local tracker = Rectangle:new():init(self);
		local v = math.mod(k,2);
		if(v == 0)then
			tracker:SetBackgroundColor("#ff0000");
		else
			tracker:SetBackgroundColor("#00ff00");
		end
		tracker:setGeometry(0,0,self.TrackerSize,self.TrackerSize);
		table.insert(self.trackers,tracker);

		tracker.handle_index = k;
		tracker.mousePressEvent = function(t, event)
			local index = t.handle_index;
			commonlib.echo("==============handle_index");
			commonlib.echo(index);
			event:accept();

			self.dragging_index = index;

			local x,y = ParaUI.GetMousePosition()

			self.start_dragging_x = x;
			self.start_dragging_y = y;

			self.old_rect.x = self:x();
			self.old_rect.y = self:y();
			self.old_rect.width = self:width();
			self.old_rect.height = self:height();

		end
		self.mouseReleaseEvent = function(t, event)
			 commonlib.echo("==============mouseReleaseEvent");
			commonlib.echo(event);
			
			self.dragging_index = nil;
		end
	end	

	self.timer = commonlib.Timer:new({callbackFunc = function(timer)
		local index = self.dragging_index;
		if(index)then
			local tracker = self.trackers[index];
			if(tracker)then
				local x,y = ParaUI.GetMousePosition()
				local dx = x - self.start_dragging_x;
				local dy = y - self.start_dragging_y;


				local width = self.old_rect.width;
				local height = self.old_rect.height;


				if(index == 4)then
					width = width + dx;
				elseif(index == 5)then
					width = width + dx;
					height = height + dy;
				elseif(index == 6)then
					height = height + dy;
				end
				self:resize(width,height);
				self:layoutTrackers();

				local window = self:GetWindow();
				if(window)then
					local _x, _y, _width, _height = window.native_ui_obj:GetAbsPosition();
					window:setGeometry(_x,_y,width,height);
				end
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


