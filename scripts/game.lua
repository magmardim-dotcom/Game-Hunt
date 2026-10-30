local scripts = load.scripts('scripts/game_screen')
local screenCords = load.json('jsons/game_screen.json')

local game = {}
local world = {}
	world.width = 6
	world.height = 6

function game.load()
	local width, height = world.width, world.height
	world.map, world.rooms = scripts.generation(width, height, set:new(4,1,1,1,1,1,1,1,1,1,1,1,1,2,3), 6)	
	
	for _, v in pairs(screenCords.layers[1].objects) do
		if scripts[v.name] then
			scripts[v.name].screen.x = v.x
			scripts[v.name].screen.y = v.y
			scripts[v.name].screen.width = v.width
			scripts[v.name].screen.height = v.height
		end		
	end
	
	scripts.miniMap:render(world.rooms, width, height)
	scripts.globalMap.map = world.map
end

function game:draw()
	scripts.globalMap.screen:draw()
	scripts.miniMap.screen:draw()
end

function game:update(dt)

end

function game:keypressed(key)
	if key == 'left' then
		scripts.globalMap.offsetX = scripts.globalMap.offsetX - 32
	elseif key == 'right' then
		scripts.globalMap.offsetX = scripts.globalMap.offsetX + 32 
	elseif key == 'up' then
		scripts.globalMap.offsetY = scripts.globalMap.offsetY - 32
	elseif key == 'down' then
		scripts.globalMap.offsetY = scripts.globalMap.offsetY + 32
	end
end

return game
