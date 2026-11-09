local status = require "scripts/objs/status"
local obj = require "scripts/objs/obj"
local knowledge = require "scripts/objs/knowledge"
local char = class:new(obj)
	char.color = {1,1,1}
	char.type = "Person"
	char.visibility = 2

function char:new(o, world)
	o = o or {}
	o.x = o.x or 1
	o.y = o.y or 1
	o.dx = 0
	o.dy = 0
	o.alpha = 1
	o.delay = 1
	o.world = world
	
	o.status = 'research'
	o.knowledge = knowledge:new()
		o.knowledge:setmap(o.x, o.y)
	
	o.targert = nil
	o.path = path:new(o.x, o.y, world.map)
	o.dirs_weigh = {
		{1,0,1},{0,1,1},{-1,0,1},{0,-1,1}
	}
		
	return self.__create(o)
end

function char:update(dt) 
	if self.alpha <= 0.1 then self.alpha = 1 end
	self.alpha = lerp(self.alpha, 0, dt * 2)
	
	self.delay = self.delay - dt
	if self.delay < 0 then		
		--~ print(self.target)
		self:action()
		self.delay = .05
		self:perceive(self.world.map)
	end
end	

function char:where()
	local where = self.world:whereCord(self.x, self.y)
	
	
	if where then 
		if self.inroom ~= where then self.from = self.inroom end
		self.inroom = where 
	end 
	
	return self.inroom
end

function char:moveTo(x, y)
    self.x, self.y = x, y
    
    return self	
end

function char:getInfo()
	return {
		'%{0,1,0}'..self.type..': %{1,1,1}#'..self:getID()
	}
end

local function bresenhamLine(x0, y0, x1, y1, globalmap, memorymap)
    local dx = math.abs(x1 - x0)
    local dy = -math.abs(y1 - y0)
    local sx = x0 < x1 and 1 or -1
    local sy = y0 < y1 and 1 or -1
    local err = dx + dy             
	
    while true do
		if globalmap:get(x0, y0) == 1 then 
			return true
		end
		
		memorymap:setmap(x0, y0)
		 
        if (x0 == x1 and y0 == y1) then break end
        local e2 = 2 * err
        if e2 >= dy then
            err = err + dy
            x0 = x0 + sx
        end
        if e2 <= dx then
            err = err + dx
            y0 = y0 + sy
        end
    end
    return false
end

function char:action()
	local nextmove = table.remove(self.path.path, 1)
	
	if nextmove then
		self:moveTo(nextmove.x, nextmove.y)						
	end
				
	if self.target and self.x == self.target.x and self.y == self.target.y then 
		self.target = nil 
		self.path.goal = nil
	end
	status[self.status].action(self)
end

function char:perceive(map)
	local where = self:where()
	local know = self.knowledge
	
	--~ know:setroom(where)
		
	local r = self.visibility
		
	for y = self.y-r, self.y+r do 
		for x = self.x-r, self.x+r do
			bresenhamLine(self.x, self.y, x, y, map, know)
			
			for k, door in ipairs(Door:getInstances()) do
				if door.x == x and door.y == y then
					know:setdoor(where, door)
				end	
			end			
		end
	end
end

function char:new_target(target) 
	if target then 
		local path = self.path
		self.target = {x = target.x, y = target.y}
		if not path:hasTarget() then
			path.start.x = self.x
			path.start.y = self.y
			path:search(target.x, target.y)
		end
	end	
	
	return self
end

function char:getDoors()
	local where = self:where()
	
	return self.knowledge:getdoors(where)
end

return char

