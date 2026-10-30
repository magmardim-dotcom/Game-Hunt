local globalMap = {}
	globalMap.offsetX = 0
	globalMap.offsetY = 0

local screen = {
	width = 768 * window.scaleW,
	height = 352 * window.scaleH
	
}

function screen:drawing() 
	local game = globalMap.game
	local scale = window:getScale()
	local size = game.defaults.size * scale
	local map = globalMap.map
	local h, w = #map, #map[1]
	local brs = 6
	local ox = (self.width/2) - globalMap.offsetX
	local oy = (self.height/2) - globalMap.offsetY
	
	love.graphics.push()
	love.graphics.setLineWidth(scale)
	love.graphics.setColor(0, .47, .6, 1)
	love.graphics.rectangle('fill', 0, 0, self.width, self.height)
	love.graphics.translate(ox, oy)
	love.graphics.setColor(0, .15, .34, 1)
	for y = 1, h do
		for x = 1, w do
			if map[y][x] ~= 1 then 						
				love.graphics.rectangle('fill', (x-brs-1) * size, (y-brs-1) * size, size-scale, size-scale)
			end
			 
		end
	end	
	
	for _, o in ipairs(game.objs) do
		if o.draw then o:draw(size) end
	end 
	
	love.graphics.setColor(1,1,1)
	love.graphics.pop()
end

globalMap.screen = Screen:new(screen)

return globalMap
