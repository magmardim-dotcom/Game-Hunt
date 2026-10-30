require "init"
require "scripts/utilits"

local game = require 'scripts.game'

function love.load()
	--~ math.randomseed(os.time())
	math.randomseed(13)
	game:load()
	
	
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
	
	-- dbg
	stats = love.graphics.getStats()
end

function love.keypressed(key)
	game:keypressed(key)
	
	
	-- dbg
	if key == 'f2' then 
		love.event.quit('restart') 
	end
	
	if key == '`' then
		dbg:p(stats)
	end
end

function love.resize( w, h )
	window.refreshScale(w, h)
end


