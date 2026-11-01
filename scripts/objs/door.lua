local obj = require "scripts/objs/obj"
local door = class:new(obj)
	door.color = {0,1,0}
	door.loc = false
	door.type = "Door"
	
function door:switch(c)
	self.loc = c
	self.color = self.loc and {1,0,0} or {0,1,0}
	return self
end

function door:getRooms(rooms)
	if self.r1 and self.r2 then return self.r1, self.r2 end 
	
	for _, room in ipairs(rooms) do
		if room:cordinateIsRoom(x, y, self.defaults.brs) then
		
		end
	end	
end
	

return door 
