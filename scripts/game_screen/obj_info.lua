local info = {}
local screen = {}

function screen:drawing()
	local width, height = self.width, self.height
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('line', 0, 0, width, height)
end

info.screen = Screen:new(screen)

return info
