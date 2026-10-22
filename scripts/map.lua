local map = {}

local roomType = {
	[1] = {w = 1, h = 1},
	[2] = {w = 2, h = 1},
	[3] = {w = 1, h = 2},
	[4] = {w = 2, h = 2}
}

local function newroom(x, y, w, h, p)
    return {x = x, y = y, width = w, height = h}
end 

directions = {
		{1,0}, {-1,0}, {0,1}, {0,-1}
	}

local function step(a, b, c)
	if c == 0 then 
		return a + (b - 1)
	else
		return a + (b * c)
	end
end	

local function fill(map, rect, v) 
    for i = rect.x, rect.x + rect.width - 1 do
        for j = rect.y, rect.y + rect.height - 1 do
            map:set(i, j, v)
        end
    end	
end

local function is_inside(x, y, t)
    for _, c in ipairs(t) do
		if c.x == x and c.y == y then
			return true
       end
    end
	return false
end

local function getneighbours(node, map)
	 local directions = {
		{1,0}, {-1,0}, {0,1}, {0,-1}
	}
	local cells = set:new()
	local doors = set:new()
	 
	for y = node.y, node.y + node.height - 1 do
		for x = node.x, node.x + node.width - 1 do
			cells:add({x = x, y = y})
		end
	end    	
    
    for _, cell in ipairs(cells) do
        for _, d in ipairs(directions) do
            local nx = cell.x + d[1]
            local ny = cell.y + d[2]

            if not is_inside(nx, ny, cells) then
                doors:add({x = nx, y = ny, fx = cell.x, fy = cell.y, room = node})
            end
        end
    end
    
    return doors	
end

local function can_place(map, x, y, w, h)
    local height, width = #map, #map[1]
    if x < 1 or y < 1 or
       x + w - 1 > width or y + h - 1 > height then
        return false
    end
    for i = x, x + w - 1 do
        for j = y, y + h - 1 do
            if map:get(i, j) ~= 0 then return false end
        end
    end
    return true
end

local function placement_from_neighbor(neigh, w, h)
    local nx, ny = neigh.x, neigh.y
    local r = neigh.room

    if nx == r.x - 1 and ny >= r.y and ny < r.y + r.height then
        return nx - w + 1, ny
    end
    
    if nx == r.x + r.width and ny >= r.y and ny < r.y + r.height then
        return nx, ny
    end
    
    if ny == r.y - 1 and nx >= r.x and nx < r.x + r.width then
        return nx, ny - h + 1
    end
    
    if ny == r.y + r.height and nx >= r.x and nx < r.x + r.width then
        return nx, ny
    end
    
    return nil, nil
end

function map.gen(width, height, setrooms)
	local map = matrix:new(width, height, 0)
	local firstIdx = setrooms:pull(1)
	local w, h = roomType[firstIdx].w, roomType[firstIdx].h
	local start = {x = math.floor(width/2), y = math.floor(height/2), width = w, height = h}	
	local rooms = set:new(start)
	
	fill(map, start, 1)
	
	local neighSet = set:new()
	local n = getneighbours(start)
	for i = 1, #n do
		neighSet:add(n:get(i))
	end
	
	while #setrooms > 0 do
		local roomIdx = setrooms:pull() 
		local rw, rh = roomType[roomIdx].w, roomType[roomIdx].h
		
		local placed = false
		while not placed do
            if #neighSet == 0 then
                error("map generation error 1")
            end	
            
            local cell, cellIdx = neighSet:get() 
            if not cell then error("map generation error 2") end   
            
            local x, y = placement_from_neighbor(cell, rw, rh)
            if x and y and can_place(map, x, y, rw, rh) then
                local newRoom = newroom(x, y, rw, rh)
                fill(map, newRoom, 1)
                rooms:add(newRoom)
                
                local neigh = getneighbours(newRoom)
                for j = 1, #neigh do
                    neighSet:add(neigh:get(j))
                end

                neighSet:pull(cellIdx)
                placed = true
            end                     		
		end		
	end
	
	for _, room in ipairs(rooms) do
		local neighset = set:new()
				
		local n = getneighbours(room)
		for i = 1, #n do
			neighset:add(n:get(i))
		end	
		
		room.passage = set:new()
		for _, neigh in ipairs(neighset) do
			if map[neigh.y] and map[neigh.y][neigh.x] == 1 then
				room.passage:add({sx = neigh.x, sy = neigh.y, fx = neigh.fx, fy = neigh.fy, to = neigh})
			end
		end	
	end
	
	local brs = 6 -- basic room size
	map = matrix:new(width * (brs + 1), height * (brs + 1), 1)
	
	for _, room in ipairs(rooms) do
		local x1 = (room.x * brs) + 1
		local x2 = x1 + (room.width * brs)
		local y1 = (room.y * brs) + 1
		local y2 = y1 + (room.height * brs)
		 
		for y = y1, y2-2 do
			for x = x1, x2-2 do
				map:set(x, y, 0)
			end
		end
		
		for _, p in ipairs(room.passage) do
			local sx, sy = (p.sx * brs) + brs/2, (p.sy * brs) + brs/2
			local fx, fy = (p.fx * brs) + brs/2, (p.fy * brs) + brs/2
			for y = sy, fy do
				for x = sx, fx do
					map:set(x, y, 0)
				end
			end
		end
	end
	
	return map, rooms
end

function map.draw(m, r)
	local scale = 1
	local size = 10 * scale
	
	love.graphics.setLineWidth(scale)
	
	for y = 1, #m do
		for x = 1, #m[1] do
			if m[y][x] == 1 then 
				love.graphics.setColor(0.2, 0.2, 0.2, 1)
			else
				love.graphics.setColor(0.4, 0.4, 0.4, 1)
				love.graphics.rectangle('fill', (x-1) * size, (y-1) * size, size-scale, size-scale)
			end
			 
		end
	end
	
	for k,v in ipairs(r) do
		local x, y = (v.x-1) * size, (v.y-1) * size
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle('fill', x, y, v.width * size, v.height * size)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle('line', x, y, v.width * size, v.height * size)
		love.graphics.setColor(1, 1, 1, 1)
		for _, p in ipairs(v.passage) do
			local sx, sy = (p.sx-1) * size, (p.sy-1) * size
			local fx, fy = (p.fx-1) * size, (p.fy-1) * size
			love.graphics.line(sx + size/2, sy + size/2, fx + size/2, fy + size/2)
		end
	end
end

return map
