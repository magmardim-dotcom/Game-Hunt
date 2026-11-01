local cursor = require "scripts.cursor"	

local globalMap = {}
	globalMap.offsetX = 0
	globalMap.offsetY = 0

local screen = {}

function screen:drawing() 
	local game = globalMap.game
	local scale = window:getScale()
	local size = game.defaults.size * scale
	local map = globalMap.map
	local h, w = #map, #map[1]
	local ox = (self.width/2) - globalMap.offsetX
	local oy = (self.height/2) - globalMap.offsetY
	
	love.graphics.push()
	love.graphics.setLineWidth(scale)
	love.graphics.setColor(0.1, 0.1, 0.1, 1)
	love.graphics.rectangle('fill', 0, 0, self.width, self.height)
	love.graphics.translate(ox, oy)		
	
	for o = #game.world.objs, 1, -1 do
		local obj = game.world.objs[o]
		if obj then obj:draw(size) end
	end
	
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setColor(0.5, 0.5, 0.5, 1)
	for y = 1, h do
		for x = 1, w do
			if map[y][x] == 0 then 				
				local x1, y1 = (x-1) * size, (y-1) * size 			-- top  left
				local x2, y2 = x1 + size, y1 						-- top  right
				local x3, y3 = x2, y2 + size						-- down right
				local x4, y4 = x1, y3								-- down left 
				
				love.graphics.line({x1, y1, x2, y2, x3, y3, x4, y4, x1, y1})
			elseif map[y][x] == 2 then
				love.graphics.rectangle('fill', (x-1) * size, (y-1) * size, size, size)
			end
			 
		end
	end	
	
	cursor:draw(size)	
	love.graphics.setColor(1,1,1)
	love.graphics.pop()
	love.graphics.rectangle('line', 0, 0, self.width, self.height)
end

globalMap.screen = Screen:new(screen)

return globalMap
