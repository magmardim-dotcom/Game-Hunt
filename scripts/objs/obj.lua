local Obj = class:new()

function Obj:new(o, world)
	o = o or {}
	o.x = o.x or 1
	o.y = o.y or 1
	o.alpha = 1
	o.world = world 
	
	return self.__create(o)
end

function Obj:draw(size) 
	local color = self.color
	love.graphics.push()
	love.graphics.setColor(color[1] or 1, color[2] or 1, color[3] or 1, self.alpha)
	love.graphics.rectangle('fill', (self.x - 1) * size, (self.y - 1) * size, size, size)
	
	love.graphics.setColor(0,0.2,0,0.8)
	if self.knowledge then
		for y, row in pairs(self.knowledge.map) do
			for x, col in pairs(row) do
				if col then
					love.graphics.rectangle('fill', (x - 1) * size, (y - 1) * size, size, size)
				end
			end
		end
	end
	
	love.graphics.setColor(.2,0,0,0.8)
	if self.path then
		for _, p in ipairs(self.path.path) do
			local x,y = p.x, p.y
			
			--~ love.graphics.rectangle('fill', (x - 1) * size, (y - 1) * size, size, size)
		end
	end
	
	love.graphics.pop()
end

function Obj:where()
	return self.world:whereCord(self.x, self.y)
end

function Obj:getInfo()
	return {
		"%{1,0,0}error: unknown object"
	}
end

function Obj:say(msg)
	msg = self:getID() .. ': ' .. msg
	print(msg)
end

function Obj:getID()
	local s = tostring(self)
	return s:sub(#s-4, #s) 
end

return Obj
