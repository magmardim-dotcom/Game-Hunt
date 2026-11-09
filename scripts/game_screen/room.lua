local room = {}
local brs = 6
room.__index = room

function room:new(x, y, w, h)
	local r = {}
	r.x = x
	r.y = y
	r.width = w
	r.height = h
	r.passage = set:new()
	return setmetatable(r, self)
end

function room:getcenter()
	local x = (self.x + self.width/2) * brs
	local y = (self.y + self.height/2) * brs
	return x, y
end

function room:getBounds()
	local x1 = self.x * brs
	local y1 = self.y * brs
	local x2 = (self.x + self.width) * brs
	local y2 = (self.y + self.height) * brs
	
	return x1, y1, x2, y2
end

function room:cordinateTouchRoom(x, y)
	local x1, y1, x2, y2 = self:getBounds()
	local cords = {}
	
	if x >= x1 and x <=x2 and y >= y1 and y <=y2 then
		return true
	end
	
	return false
end

function room:cordinateIsRoom(x, y)
	local x1, y1, x2, y2 = self:getBounds()
	
	if x >= x1+1 and x <=x2-1 and y >= y1+1 and y <=y2-1 then
		return true
	end
	
	return false
end

function room:getdoors()
	local doors = {}
	
	for _, door in pairs(Door:getInstances()) do
		if self:cordinateTouchRoom(door.x, door.y) then
			table.insert(doors, door)
		end
	end
	
	return doors
end

function room:getID()
	local s = tostring(self)
	return s:sub(#s-4, #s) 
end

return room
