local cursor = require "scripts.cursor"	

local globalMap = {}
	globalMap.offsetX = 0
	globalMap.offsetY = 0

local screen = {}


local function drawGrid(size, width, height, ox, oy)
	love.graphics.setColor(0.4, 0.4, 0.4, 1)

	local firstX = math.floor(-ox / size) - 1
	local lastX  = math.ceil((width - ox) / size) + 1
	local firstY = math.floor(-oy / size) - 1
	local lastY  = math.ceil((height - oy) / size) + 1

	for i = firstX, lastX do
		love.graphics.line(i * size, -oy, i * size, height - oy)
	end
	for j = firstY, lastY do
		love.graphics.line(-ox, j * size, width - ox, j * size)
	end
end

function screen:drawing() 
	local game = globalMap.game
	local scale = window:getScale()
	local size = defaults.size * scale
	local map = globalMap.map
	local h, w = #map, #map[1]
	local ox = (self.width/2) - globalMap.offsetX
	local oy = (self.height/2) - globalMap.offsetY	
	
	love.graphics.push() 
	love.graphics.setLineWidth(scale)	
	love.graphics.setColor(0.1, 0.1, 0.1, 1)
	love.graphics.rectangle('fill', 0, 0, self.width, self.height)	
	love.graphics.translate(ox, oy)
	drawGrid(size, self.width, self.height, ox, oy)	
		
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setColor(1, 1, 1, 1)
	for y = 1, h do
		for x = 1, w do
			if map[y][x] == 1 then
				love.graphics.rectangle('fill', (x-1) * size, (y-1) * size, size, size)
			end			 
		end
	end	
	love.graphics.setBlendMode("alpha", "alphamultiply")
	for o = #game.world.objs, 1, -1 do
		local obj = game.world.objs[o]
		if obj then obj:draw(size) end
	end
	
	cursor:draw(size)	
	love.graphics.setColor(1,1,1)
	love.graphics.pop()
	love.graphics.rectangle('line', 0, 0, self.width, self.height)
end

globalMap.screen = Screen:new(screen)

return globalMap
