local dbg = {}
	dbg.font = love.graphics.getFont()
	dbg.color = {0,1,0}
	dbg.stats = {}
	
function dbg:update(stats)	
	local res = {
		'...',
		string.format("OS is %s", love.system.getOS()),
		string.format("FPS: %d", love.timer.getFPS()),
		string.format("Memory: %.0f", collectgarbage('count')),
		string.format("Texture Mem: %.0f KB", math.floor(stats.texturememory / 1024)),
		string.format("Images: %d", stats.images),
		string.format("Draw Calls: %d", stats.drawcalls),
		string.format("Fonts: %d", stats.fonts),
		string.format("Canvas: %d", stats.canvases),
		string.format("Width: %d Height: %d", love.graphics.getWidth(), love.graphics.getHeight()),
		'\n__Classes:',
		string.format("Texts: %d", #Text:getInstances()),
		string.format("Menus: %d", #Menu:getInstances()),
		string.format("Screens: %d", #Screen:getInstances())
	}
	
	res = table.concat(res, '\n')
	
	return res
end

function dbg:p(stats)
	print(self:update(stats))
end

function dbg:draw(x, y)
	x, y = x or 0, y or 0
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.setColor(self.color)
	love.graphics.setFont(self.font)
	love.graphics.print(self:update(stats))
	love.graphics.pop()
end

return dbg
