local obj = require "scripts/objs/obj"
local door = class:new(obj)
	door.color = {0,1,0}
	door.lock = false
	door.type = "Door"
	
function door:switch()
	self.lock = not self.lock
	self.color = self.lock and {1,0,0} or {0,1,0}
	self.world.map:set(self.x, self.y, self.world.map:get(self.x, self.y) == 1 and 0 or 1) 
	
	return self
end

function door:getRoomsConnected()
	if self.connects then 
		return self.connects 
	end
	
	local rooms = self.world.rooms
	local connects = {}
	
	for _, room in ipairs(rooms) do 
		if room:cordinateTouchRoom(self.x, self.y) then  
			table.insert(connects, room)
		end
	end	
	self.connects = connects
	
	return connects
end

function door:goto(from_roomid)
	if not self.connects then
		self:getRoomsConnected()
	end
	
	if self.connects[1]:getID() == from_roomid then
		return self.connects[1]
	else
		return self.connects[2]
	end
end

function door:getInfo()
	return {
		self.type..': %{1,1,1}'..self:getID(),
		'status: '..(self.lock and '%{1,0,0}close' or '%{0,1,1}open')
	}
end
	

return door 
