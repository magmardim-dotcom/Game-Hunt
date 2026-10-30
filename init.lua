local folder = 'librarys'
local paths = love.filesystem.getRequirePath( )
love.filesystem.setRequirePath( paths..';librarys/?.lua;' )
	
local items = love.filesystem.getDirectoryItems(folder)
	
if #items <= 0 then return end
	
for _,item in ipairs(items) do
		 
	local i = string.find(item, "%.lua")
		
	if not i then
		_G[item] = require (item.."/init")
	else
		item = item:sub(1, i-1)
		_G[item] = require (item)
	end
end
