local function dist(x0, y0, x1, y1)
	return (x0 - x1)^2 + (y0 - y1)^2
end

local function findNearestUnvisited(char) 
	if char.target then return false end
	local where = char:where()
	local x1, y1, x2, y2 = where:getBounds()
	local target = {}
	local bestDist = math.huge
	local known = 0
	local room = char.memory_rooms[where:getID()]
	
	if room.explored > 0.96 then
		room.explored = 1
		for _,door in ipairs(where:getdoors()) do
			local id = door:getID()
			if not room.doors[id] then 
				room.doors[id] = {x = door.x, y = door.y, loc = false, to = nil, origin = door}
			end
		end
		
		char.status = 'find_room'
		return false
	end
	
	for y = y1+1, y2-1 do
		for x = x1+1, x2-1 do
			if not char.memory[y] or not char.memory[y][x] then
				local dist = dist(x, y, char.x, char.y)
				--~ local noise = math.random(-10, 10)
				local noise = 0
				local r = math.random() 
				if r > .7 then dist = dist + noise end
				if dist < bestDist then
					bestDist = dist 
					target = {x = x, y = y}
                end
                known =  known + 1
                
			end
		end
	end
	
	local area = (x2-x1) * (y2-y1)
	local percent_explored = (area - known)/area	
	room.explored = percent_explored
		
    return target
end

return {
	['idle'] = {
		action = function(char)
			
		end
	},
	['find_room'] = {
		action = function(char) 
			--~ if char.target then return end
			
			--~ local target_door = nil
			--~ local memory_doors = char:getMemDoors()
			--~ local doors = {}
			--~ local doors_explored = {}
			
			--~ for k, v in pairs(memory_doors) do
				--~ if not v.to then
					--~ table.insert(doors, v)
				--~ else 
					--~ table.insert(doors_explored, v)
				--~ end
			--~ end
			
			--~ if #doors > 0 then
				--~ target_door = doors[math.random(1, #doors)]
			--~ else
				--~ target_door = doors_explored[math.random(1, #doors_explored)]
			--~ end
			
			--~ if target_door then 
				--~ local id = target_door.origin:getID()
				--~ local toroom = target_door.origin:goto(id)
				--~ memory_doors[id].to = toroom
				--~ local cx, cy = toroom:getcenter()
				--~ char:new_target({x = cx, y = cy})
				
				--~ char.status = 'research'
			--~ else
				--~ char.status = 'idle'
			--~ end
		end
	},
	['research'] = {
		cost = function(char)
			
		end,		
		action = function(char)	
			--~ if not char.target then 		
				--~ local target = findNearestUnvisited(char) 
			
				--~ if target and target.x and target.y then char:new_target(target) end
			--~ end
		end
	}
}
