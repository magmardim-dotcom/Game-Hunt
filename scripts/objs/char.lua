local obj = require "scripts/objs/obj"
local char = class:new(obj)
	char.color = {1,1,1}

function char:update(dt) 
	if self.alpha <= 0.1 then self.alpha = 1 end
	self.alpha = lerp(self.alpha, 0, dt * 2)
end	

function char:where()
	return self.inroom
end

return char

