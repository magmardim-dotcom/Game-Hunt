local room = {}
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

function room:getcenter(brs)
	local x = (self.x + self.width/2) * brs
	local y = (self.y + self.height/2) * brs
	return x, y
end

function room:cordinateIsRoom(x, y, brs)
	local x1 = self.x * brs
	local y1 = self.y * brs
	local x2 = (self.x + self.width) * brs
	local y2 = (self.y + self.height) * brs
	
	if x >= x1 and x <=x2 and y >= y1 and y <=y2 then
		return true
	end
	return false
end

return room
