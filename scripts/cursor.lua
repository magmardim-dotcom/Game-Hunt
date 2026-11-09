local cursor = {}

function cursor:draw(size)
	love.graphics.push()
	love.graphics.setLineWidth(4 * window:getScale())
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle('line', (self.x - 1) * size, (self.y - 1) * size, size, size)
	love.graphics.pop()
end

function cursor:info(objs, x, y)
	for o = 1, #objs do
		local obj = objs[o]
		if obj.x == self.x and obj.y == self.y then 
			return obj
		end
	end
	return false
end

return cursor
