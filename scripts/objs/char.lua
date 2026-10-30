local obj = require "scripts/objs/obj"
local char = class:new(obj)

function char:new(o)
	o = o or {}
	o.x = o.x or 1
	o.y = o.y or 1
	o.color = {1,0,0}
	
	return self.__create(o)
end

return char

