local settings = {
	scale = 1,
	size = 14
}

local mainMap = {}
local miniMap = {}

function mainMap:render(map, brs)
	local scale = settings.scale
	local size = settings.size * scale
	local h, w = #map, #map[1]
	
	if not self.canvas then
		self.canvas = love.graphics.newCanvas((w - brs + 1) * size, (h - brs + 1) * size)
	end
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
	love.graphics.setLineWidth(scale)
	
	love.graphics.setColor(0, .47, .6, 1)
	love.graphics.rectangle('fill', 0, 0, (w - brs + 1) * size, (h - brs + 1) * size)
	
	for y = 1, h do
		for x = 1, w do
			if map[y][x] ~= 1 then 				
				love.graphics.setColor(0, .15, .34, 1)
				love.graphics.rectangle('fill', (x-brs) * size, (y-brs) * size, size-scale, size-scale)
			end
			 
		end
	end	
	love.graphics.setColor(1,1,1)
	love.graphics.setCanvas()
end

function miniMap:render(rooms, width, height)
	local scale = settings.scale
	local size = settings.size * scale * 2	
	width, height = width * size, height * size
	
	if not self.canvas then
		self.canvas = love.graphics.newCanvas(width + (4 * scale), height + (4 * scale))
	end
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()	
	love.graphics.setLineWidth(2 * scale)
	love.graphics.translate(scale * 2, scale * 2)
	love.graphics.setColor(.4, .68, .83, 1)
	love.graphics.rectangle('fill', 0, 0, width, height)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('line', 0, 0, width, height)
	
	for k,v in ipairs(rooms) do
		local x, y = (v.x-1) * size, (v.y-1) * size
		love.graphics.setColor(.19, .35, .64, 1)
		love.graphics.rectangle('fill', x, y, v.width * size, v.height * size)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle('line', x, y, v.width * size, v.height * size)
		love.graphics.setColor(.19, .35, .64, 1)
		for _, p in ipairs(v.passage) do
			local sx, sy = (p.sx-1) * size, (p.sy-1) * size
			local fx, fy = (p.fx-1) * size, (p.fy-1) * size
			love.graphics.line(sx + size/2, sy + size/2, fx + size/2, fy + size/2)
		end
	end	
	love.graphics.setColor(1,1,1)
	love.graphics.setCanvas()
end

return {
	settings = settings,
	main = mainMap,
	mini = miniMap
	
}
