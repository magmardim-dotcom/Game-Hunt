require "init"
require "scripts/utilits"

local game = require 'scripts.game'

function love.load()
	math.randomseed(os.time())
	game:load()
	
	local canvas = love.graphics.newCanvas(32, 32)
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('fill', 0, 0, 31, 31)
	love.graphics.setCanvas()
	
	local data = canvas:newImageData()
	image = love.graphics.newImage( data )
	
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


