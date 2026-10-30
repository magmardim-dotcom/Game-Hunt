local load = {}

local function scan(folder)
	local files = {}
	local items = love.filesystem.getDirectoryItems(folder)
		
	if #items <= 0 then return end
	
	for k,item in ipairs(items) do
		files[k] = {folder = folder, name = item}
	end
	return files
end

function load.scripts(folder)
	local files = scan(folder)
	local scripts = {}
	
	for _, file in ipairs(files) do
		local i = string.find(file.name, "%.lua")
		file.name = file.name:sub(1, i-1)
		scripts[file.name] = require(file.folder .. '/' .. file.name) 
	end
	return scripts
end

function load.json(fileName)
	local file = love.filesystem.read(fileName)
	return dkjson.decode(file)
end


return load
