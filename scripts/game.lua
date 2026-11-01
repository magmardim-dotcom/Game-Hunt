local scripts = load.scripts('scripts/game_screen')
local screenCords = load.json('jsons/game_screen.json')

local game = {}
local world = {}
	world.width = 6
	world.height = 6
	world.objs = {}

local cursor = require "scripts.cursor"	


function game:load() 
	local width, height = world.width, world.height
	self.defaults = scripts.defaults
	self.world = world
	world.map, world.rooms, doors = scripts.generation(
		width, height, set:new(4,1,1,1,1,1,1,1,1,1,1,1,1,2,3), self.defaults.brs
		--~ width, height, set:new(4,1), self.defaults.brs
		)
	
	for _, v in pairs(screenCords.layers[1].objects) do
		if scripts[v.name] then
			scripts[v.name].screen.x = v.x
			scripts[v.name].screen.y = v.y
			scripts[v.name].screen.width = v.width * window.scaleW
			scripts[v.name].screen.height = v.height * window.scaleH
		end		
	end
		
	local r = world.rooms:get(1) 
	local rx, ry = r:getcenter(self.defaults.brs)
	world.objs[1] = Char:new{
		x = rx,
		y = ry,
		inroom = r
	}
	world.player = world.objs[1]
	
	cursor.x, cursor.y = rx, ry	
		
	for k, d in pairs(doors) do
		local newDoor = Door:new{x = d.x, y = d.y}:switch(d.loc)
		table.insert(world.objs, newDoor)
	end
	
	scripts.globalMap.game = self
	scripts.globalMap.map = world.map	
	
	scripts.miniMap:render(world.rooms, width, height)
end

function game:draw() 
	scripts.globalMap.screen:draw()
	scripts.miniMap.screen:draw()
	scripts.obj_info.screen:draw()
end

function game:update(dt)
	local player = self.world.player
	local size = self.defaults.size
	local brs = self.defaults.brs
	
	scripts.globalMap.offsetX = (cursor.x - 1) * size
	scripts.globalMap.offsetY = (cursor.y - 1) * size
	
	for _, o in ipairs(world.objs) do
		if o.update then o:update(dt) end
	end 
end

function game:keypressed(key)
	local world = self.world
	if key == 'left' then
		cursor.x = cursor.x - 1
	elseif key == 'right' then
		cursor.x = cursor.x + 1 
	elseif key == 'up' then
		cursor.y = cursor.y - 1
	elseif key == 'down' then
		cursor.y = cursor.y + 1
	end
	
	local def = self.defaults
	if key == '-' and def.size >= 12 then
		def.size = def.size - 2
	elseif key == '=' then
		def.size = def.size + 2
	end
	
	if key == 'x' then
		cursor:info(world.objs, cursor.x, cursor.y)
	end
end

function game:whereCord(x, y)
	for _, room in ipairs(world.rooms) do
		if room:cordinateIsRoom(x, y, self.defaults.brs) then
		
		end
	end
	
end

return game
