local matrix = {}
matrix.__index = matrix

function matrix:new(w, h, val)
	local obj = {}
		w = w or 1
		h = h or 1
	
	for y = 1, h do
		obj[y] = {}
		for x = 1, w do
			obj[y][x] = val or 0
		end
	end	
	
	return setmetatable(obj, self)
end

function matrix:__tostring()
	local t = ''
	
	for y = 1, #self do
		t = t .. table.concat(self[y]) .. '\n'
	end
	
	return t
end

function matrix:set(x,y, v)
	self[y][x] = v
end

function matrix:get(x,y)
	return self[y][x]
end

function matrix:getLenght()
	return #self[1], #self
end

function matrix:copy()
	local clone = matrix:new(self:getLenght())
	
	for y = 1, #self do
		for x = 1, #self[1] do
			clone[y][x] = self[y][x]
		end
	end
	
	return clone
end

function matrix:rotate(dir)  
	local m, n = self:getLenght()
	local res = matrix:new(n, m)
	
	if dir == 1 then
        for y = 1, n do
            for x = 1, m do
				res:set(n-y+1, x, self[y][x])
            end
        end
    else
        for y = 1, n do
            for x = 1, m do				
				res:set(y, m-x+1, self:get(x, y))
            end
        end
    end
    return res
    
end

return matrix
