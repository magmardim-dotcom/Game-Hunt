local set = {}
set.__index = set

function set:new(...)
	local obj = {}
	
	for k, v in ipairs({...}) do
        obj[k] = v
    end		
	
	return setmetatable(obj, self)
end

function set:__tostring()	
	if #self == 0 then 
		return 'empty'	
	else
		local s = ''
		for k, v in pairs(self) do
			s = s .. tostring(v) .. ' '
				
		end
		return s
	end
end

function set:add(...)
	for _, v in ipairs({...}) do
        self[#self + 1] = v
    end	
end

function set:pull(n)
	if n then
		return table.remove(self, n)
	else
		local r = math.random(1, #self)
		return table.remove(self, r)
	end
end

function set:get(n)
	if #self == 0 then return false end
	if n then
		if not self[n] then return false else
		return self[n] end
	else
		local r = math.random(1, #self)
		return self[r], r
	end
	
end

function set:copy()
	local clone = set:new()
	
	for k, v in pairs(self) do
		if type(v) == "table" then
			clone[k] = self:copy(v)
		else
			clone[k] = v
		end
	end
	
	return clone
end

return set
