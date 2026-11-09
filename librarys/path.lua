local Heap = require "librarys/heap"

local dir = {
	{1,0}, {-1,0}, {0,1}, {0,-1}
}

local h = function(start, goal)
    local sx, sy = start.x, start.y
    local gx, gy = goal.x, goal.y
	
	return math.abs(sx-gx) + math.abs(sy-gy)
end

local getNeighbors = function(v, map)
    local neighbors = {}
	local x,y = v.x, v.y
	
    for _, d in ipairs(dir) do
        local nx = x + d[1]
        local ny = y + d[2]
		
		if map[ny] and map[ny][nx] and map[ny][nx] ~= 1 then
            neighbors[#neighbors+1] = {x = nx, y = ny}
        end
    end
    return neighbors
end

local astar = function(start, goal, map) 
	local openset = Heap:new()
	local closedset = {}
	local camefrom = {}
	
	local current = {
		v = start,
		g = 0,
		f = 0 + h(start, goal)
	}
	
	openset:push(current)
	
	while not openset:empty() do 
		current = openset:pop()
		
		if current.v.x == goal.x and current.v.y == goal.y then
			local path = {}
			local node = current.v
			
			while node do
				table.insert(path, node)
				node = camefrom[node]
			end
			
			local result = {}
			
			for i = #path, 1, -1 do
				result[#result+1] = path[i]
			end
			
			return result
		end
		
		closedset[current.v] = true
		
		local neighbors = getNeighbors(current.v, map)
		
		for _, n in ipairs(neighbors) do
			if not closedset[n] then
				local tentative_g = current.g + 1
				local is_in = openset:is_in(n)
				
				if not is_in or tentative_g < is_in.g then
					camefrom[n] = current.v
					
					local neighbor = {
							v = n,
							g = tentative_g,
							f = tentative_g + h(n, goal)
						}
						
					if not is_in then
						openset:push(neighbor)
					else
						openset:decreaseKey(neighbor)
					end
					
					
				end
			end
		end
	end
	
	return nil
end

local Path = {}
Path.__index = Path

function Path:new(x, y, map)
    local path = {}    
		path.start = {x = x, y = y}
		path.goal = nil
		path.map = map
		path.path = {}

    return setmetatable(path, self)
end

function Path:search(gx, gy) 
	self.goal = {x = gx, y = gy}
	self.path = astar(self.start, self.goal, self.map) 
end

function Path:hasTarget()
	return self.goal
end

return Path
