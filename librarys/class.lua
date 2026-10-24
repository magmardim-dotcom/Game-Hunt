local class = {}

local function create(cls, o)
    o = o or {}
    
    return setmetatable(o, {
        __index = function(_, k)
            local c = cls
            while c do
                local v = rawget(c, k)
                if v ~= nil then return v end
                c = c.__parent
            end
            
            c = cls
            while c do
                local v = rawget(c, "__defaults")
                if v and v[k] ~= nil then return v[k] end
                c = c.__parent
            end
            return nil
        end,
        __metatable = cls
    })
end

function class:new(parent, defaults)
    local c = {}
    c.__index = c
    c.__parent = parent
    c.__defaults = defaults
    c.__instances = setmetatable({}, {__mode = 'k'})

    if parent then
        setmetatable(c, {__index = parent})
    end

    c.__create = function(o)
		local obj = create(c, o)
		obj.__instances[obj] = true
        return obj
    end

    if rawget(c, "new") == nil then
        function c:new(o)
            o = o or {}
            
            return c.__create(o)
        end
    end
    
    function c:getInstances()
		local res = {}
		for obj, _ in pairs(self.__instances) do
			table.insert(res, obj)
		end
		return res
    end

    return c
end

return class
