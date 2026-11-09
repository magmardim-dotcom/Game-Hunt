local knowledge = {}
knowledge.__index = knowledge

function knowledge:new()
	local know = {}
		know.map = {}
		know.rooms = {}
	
	return setmetatable(know, self)
end

function knowledge:setmap(x, y)
	if not self.map[y] then self.map[y] = {} end
	self.map[y][x] = true
end

function knowledge:getmap(x, y)
	return self.map[y][x]
end

function knowledge:setroom(room)
	if not self.rooms[room] then
		-- add information about the door
		self.rooms[room] = {
			doors = {},
			explored = 0
		}
	else
		-- update knowledge about the room
	end
	
	return self.rooms[room]
end

function knowledge:setdoor(room, door)
	if not self.rooms[room] then self:setroom(room) end
	
	local know_door = self.rooms[room].doors[door]
	
	if not know_door then
		self.rooms[room].doors[door] = {
			x = door.x, 
			y = door.y, 
			lock = door.lock, 
			to = nil, 
			origin = door
		}
	else
		-- update knowledge about the door
		know_door.lock = door.lock
	end
	
	return know_door 
end

function knowledge:getdoors(room)
	return self:setroom(room).doors
end

return knowledge
