local info = {}
local screen = {}

function info:load()
	local s = self.screen
	for line = 1, 6 do
		local text = Text:new {
			width = s.width,
			y = s:getNumObj() * love.graphics.getFont():getHeight(),
			marginX = 20,
			marginY = 10,
			text_color = {0,1,0}
		}
		s:add(text, line)
	end
end

function info:cout(obj)
	if not obj then return end
	for k, v in ipairs(obj:getInfo()) do
		self.screen:getObj(k):setText(v)
	end
end

function info:rescale()
	local font = love.graphics.newFont(12 * window:getScale())
	for _, obj in pairs(self.screen.objs) do
		obj:setFont(font)
	end
end

function screen:drawing()
	local width, height = self.width, self.height
	local scale = window:getScale()
	love.graphics.setColor(0.1, 0.1, 0.1, 1)
	love.graphics.rectangle('fill', 0, 0, width, height)	
	love.graphics.setLineWidth(4 * scale)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('line', 0, 0, width, height)
end

info.screen = Screen:new(screen)

return info
