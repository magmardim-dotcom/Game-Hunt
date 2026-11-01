local Obj = class:new()

function Obj:new(o)
	o = o or {}
	o.x = o.x or 1
	o.y = o.y or 1
	o.alpha = 1
	
	return self.__create(o)
end

function Obj:draw(size) 
	local color = self.color
	love.graphics.push()
	love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, self.alpha)
	love.graphics.rectangle('fill', (self.x - 1) * size, (self.y - 1) * size, size, size)
	love.graphics.pop()
end

return Obj
