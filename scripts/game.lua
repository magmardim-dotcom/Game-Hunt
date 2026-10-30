local scripts = load.scripts('scripts/game_screen')
local screenCords = load.json('jsons/game_screen.json')

local game = {}
local world = {}
	world.width = 6
	world.height = 6


function game:load()
	local width, height = world.width, world.height
	--~ world.map, world.rooms = scripts.generation(width, height, set:new(4,1,1,1,1,1,1,1,1,1,1,1,1,2,3), 6)	
	world.map, world.rooms = scripts.generation(width, height, set:new(4), 6)	
	
	for _, v in pairs(screenCords.layers[1].objects) do
		if scripts[v.name] then
			scripts[v.name].screen.x = v.x
			scripts[v.name].screen.y = v.y
			scripts[v.name].screen.width = v.width
			scripts[v.name].screen.height = v.height
		end		
	end
	
	self.defaults = scripts.defaults
	self.objs = {}	
	local r = world.rooms:get() 
	self.objs[1] = Char:new{
		x = r.x * 7,
		y = r.y * 7
	}
	self.player = self.objs[1]
	
	scripts.globalMap.game = self
	scripts.miniMap:render(world.rooms, width, height)
	scripts.globalMap.map = world.map
end

function game:draw() 
	scripts.globalMap.screen:draw()
	scripts.miniMap.screen:draw()
	

end

function game:update(dt)
	local player = self.player
	
	scripts.globalMap.offsetX = (player.x - 1) * 32
	scripts.globalMap.offsetY = (player.y - 1) * 32
end

function game:keypressed(key)
	if key == 'left' then
		self.player.x = self.player.x - 1
	elseif key == 'right' then
		self.player.x = self.player.x + 1 
	elseif key == 'up' then
		self.player.y = self.player.y - 1
	elseif key == 'down' then
		self.player.y = self.player.y + 1
	end
end

return game
