function loadlibs(folder)
	local paths = love.filesystem.getRequirePath( )
	love.filesystem.setRequirePath( paths..';librarys/?.lua;' )
	
	local items = love.filesystem.getDirectoryItems(folder)
	
	if #items <= 0 then return end
	
	for _,item in ipairs(items) do
		 
		local i = string.find(item, "%.lua")
		
		if not i then
			_G[item] = require (item.."/init")
		else
			item = item:sub(1, i-1)
			_G[item] = require (item)
		end
	end
end

function love.load()
	loadlibs('librarys')
	require "scripts/utilits"
	
	l1 = Text:new{
		width = 400,
		height = 200,
	}:setText("Text in rectangle width: [width], height: [height]")
	
end

function love.update(dt)
	
end

function love.draw()
	for _, obj in pairs(Text:getInstances()) do
		obj:draw()
	end
	
	-- dbg
	stats = love.graphics.getStats()
	--~ dbg:draw(0, 0, stats)
end

function love.keypressed(key)
	if key == 'r' then 
		love.event.quit('restart') 
	end
	
	
	-- dbg
	if key == '`' then
		dbg:p(stats)
	end
end

function love.resize( w, h )
	window.refreshScale(w, h)
end
