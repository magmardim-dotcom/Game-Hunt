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
	screens = require "scripts/screens"
	font = 'assets/fonts/PeppaPigW1G-Regular.ttf'
		
	local l1 = screens.Text:new{
		color = 'green',
		text_color = {0,0,0},
		width = 200,
		height = 100,
	}:setText('New text: %{0,1,0}[color]')
	--~ :setFont(20, font)
	

	local m1 = screens.Menu:new{
		x = 0, y = 20, width = 200, item = 2,
		strings = {
			[1] = {
				nam = 'greate',
				act = function(s)
					
				end
			},
			[2] = {
				nam = 'old'
			}
		}
	}	
	
	main = screens.Screen:new{
		width = 400,
		height = 260,
		drawing = function(s)
			love.graphics.setColor(1,1,1)
			love.graphics.rectangle('fill', s.x, s.y, s.width, s.height)
		end,
	}:add(l1, 'l1'):add(m1, 'm1')
	
	
end

function love.update(dt)
	
end

function love.draw()
	main:draw(0, 0)
end

function love.keypressed(key)
	if key == 'r' then 
		love.event.quit('restart') 
	end
end

function love.resize( w, h )
	window.refreshScale(w, h)
end
