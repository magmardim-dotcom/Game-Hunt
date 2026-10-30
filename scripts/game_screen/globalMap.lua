local globalMap = {}
	globalMap.offsetX = 0
	globalMap.offsetY = 0

local screen = {
	width = 768 * window.scaleW,
	height = 352 * window.scaleH
	
}

function screen:drawing() 
	local scale = window:getScale()
	local size = 32 * scale
	local map = globalMap.map
	local h, w = #map, #map[1]
	local brs = 6
	
	love.graphics.push()
	love.graphics.setLineWidth(scale)
	love.graphics.setColor(0, .47, .6, 1)
	love.graphics.rectangle('fill', 0, 0, self.width, self.height)
	love.graphics.translate(-globalMap.offsetX, -globalMap.offsetY)
	love.graphics.setColor(0, .15, .34, 1)
	for y = 1, h do
		for x = 1, w do
			if map[y][x] ~= 1 then 						
				love.graphics.rectangle('fill', (x-brs) * size, (y-brs) * size, size-scale, size-scale)
			end
			 
		end
	end	
	love.graphics.setColor(1,1,1)
	love.graphics.pop()
end

globalMap.screen = Screen:new(screen)

return globalMap
