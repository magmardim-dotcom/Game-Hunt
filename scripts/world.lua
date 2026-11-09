local world = {}
	world.width = 6
	world.height = 6
	world.objs = {}

function world:whereCord(x, y)
	for _, room in ipairs(self.rooms) do
		if room:cordinateIsRoom(x, y, defaults.brs) then
			return room
		end
	end
	return false
end

return world
