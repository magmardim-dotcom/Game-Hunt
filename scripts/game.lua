local scripts = load.scripts('scripts/game_screen')
local screenCords = load.json('jsons/game_screen.json')

local game = {}
local world = require 'scripts.world'
local cursor = require "scripts.cursor"	

function game:load() 
	local width, height = world.width, world.height
	self.world = world
	self.inputText = ''
	self.inputResult = ''
	
	world.map, world.rooms, doors = scripts.generation(
		--~ width, height, set:new(4,1,1,1,1,1,1,1,1,1,1,1,1,2,3), defaults.brs
		width, height, set:new(4,4,4,4), defaults.brs
	)
	
	for _, v in pairs(screenCords.layers[1].objects) do
		local s = scripts[v.name]
		if scripts[v.name] then
			s.screen.x = v.x
			s.screen.y = v.y
			s.screen.width = v.width * window.scaleW
			s.screen.height = v.height * window.scaleH
			if s.load then s:load() end
		end		
	end
		
	local r = world.rooms:get(1) 
	local rx, ry = r:getcenter(defaults.brs)
	world.objs[1] = Char:new({
		x = rx,
		y = ry
	}, world, scripts.defaults)
	world.player = world.objs[1]
	world.player:perceive(self.world.map)
	
	cursor.x, cursor.y = rx, ry	
		
	for k, d in pairs(doors) do
		local newDoor = Door:new({x = d.x, y = d.y}, world)
		newDoor:getRoomsConnected()
		table.insert(world.objs, newDoor)
	end
	
	scripts.globalMap.game = self
	scripts.globalMap.map = world.map	
	scripts.miniMap:render(world.rooms, width, height)
end

function game:draw() 
	for _, v in pairs(screenCords.layers[1].objects) do
		local s = scripts[v.name].screen
		s:draw()
	end
end

function game:update(dt)
	local player = self.world.player
	local size = defaults.size * window:getScale()
	local brs = defaults.brs
	
	scripts.globalMap.offsetX = (cursor.x - 1) * size
	scripts.globalMap.offsetY = (cursor.y - 1) * size
	
	for _, o in ipairs(world.objs) do
		if o.update then o:update(dt) end
	end 
	
	scripts.terminal.inputText = self.inputText
end

function game:keypressed(key)
	local world = self.world
	local pl = world.player
	
	if key == 'left' then
		cursor.x = cursor.x - 1
	elseif key == 'right' then
		cursor.x = cursor.x + 1 
	elseif key == 'up' then
		cursor.y = cursor.y - 1
	elseif key == 'down' then
		cursor.y = cursor.y + 1
	end
	
	pl:moveTo(cursor.x, cursor.y)
	pl:perceive(world.map)
	
	if key == "backspace" then
        self.inputText = self.inputText:sub(1, -2)
    elseif key == 'return' then
		if scripts.commands[self.inputText] then scripts.commands[self.inputText](scripts, cursor, game) end
		local output = self.inputText..(self.inputResult ~= '' and ': ' or '')..self.inputResult
		table.insert(scripts.terminal.history, 1, output)		
		self.inputText = ''
		self.inputResult = ''
	end
	
	if key == 'x' then
			
	end
	
	local def = defaults
	if key == '-' and def.size >= 16 then
		def.size = def.size - 2
	elseif key == '=' then
		def.size = def.size + 2
	end
	
	if key == 'f12' then
		window:setFullscreen()
		
		for _, v in pairs(screenCords.layers[1].objects) do
			local s = scripts[v.name]
			if s then
				s.screen.x = v.x
				s.screen.y = v.y
				s.screen.width = v.width * window.scaleW
				s.screen.height = v.height * window.scaleH
			end		
		end
		scripts.miniMap:render(world.rooms, world.width, world.height)	
		scripts.obj_info:rescale()
		scripts.terminal:rescale()
	end
	

end

function game:textinput(text)
    --~ self.inputText = self.inputText .. text
end

return game
