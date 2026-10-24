local defaults = require 'defaults' 
local Screen = class:new(nil, defaults)

function Screen:new(o)
    o = o or {}
	o.x = o.x or 0
	o.y = o.y or 0
	o.width = o.width or 0
	o.height = o.height or 0
	o.objs = o.objs or {}
    
    return self.__create(o)
end

function Screen:draw(x, y)
	local x, y = x or self.x, y or self.y
	local window = window
	love.graphics.push('all')
	
	if not love.graphics.getScissor() then 
		love.graphics.setScissor(x * window.scaleW, y * window.scaleH, self.width * window.scaleW, self.height * window.scaleH)
	end
	
	local offsetX, offsetY, angle = 0, 0, 0
	if self.shake and self.shake.duration > 0 then
		offsetX = (math.random() * 2 - 1) * self.shake.magnitude
		offsetY = (math.random() * 2 - 1) * self.shake.magnitude
		angle   = (math.random() * 2 - 1) * self.shake.rotation
	end
    		
	love.graphics.translate((x + offsetX) * window.scaleW, (y + offsetY) * window.scaleH) 	
	love.graphics.translate(self.width/2, self.height/2)
	love.graphics.rotate(self.r + math.rad(angle))
	love.graphics.translate(-self.width/2, -self.height/2)		
	
	if self.drawing then 
		self:drawing(self) 
	end
	
	if self.objs then
		for _, obj in pairs(self.objs) do
			obj:draw()
		end	
	end	
	
	love.graphics.pop()	
end

function Screen:rotation(ang)
	self.r = self.r + ang
end

function Screen:add(obj, nam)
	if self.objs then
		self.objs[nam] = obj
	end
	obj.where = self
	
	return self
end

function Screen:update(dt)
	if self.shake and self.shake.duration > 0 then
        self.shake.duration = self.shake.duration - dt
        if self.shake.duration < 0 then
            self.shake.duration = 0
        end
    end
    
    if self.objs then
		for _, obj in pairs(self.objs) do
			obj:update(dt)
		end	
	end
end

function Screen:shakeStart(duration, magnitude, rotation)
    if not self.shake then
		self.shake = {
			duration = 0,
			magnetude = 0,
			rotation = 0
		}
    end
    
    self.shake.duration  = duration
    self.shake.magnitude = magnitude
    self.shake.rotation  = rotation
end

return Screen
