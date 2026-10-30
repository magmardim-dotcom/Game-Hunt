local Obj = class:new()

function Obj:draw(size)
	love.graphics.push()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', (self.x - 1) * size, (self.y - 1) * size, size, size)
	love.graphics.pop()
end

return Obj
