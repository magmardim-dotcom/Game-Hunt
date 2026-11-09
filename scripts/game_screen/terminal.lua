local terminal = {}
	terminal.inputText = ''
	terminal.history = {}

local screen = {}	

function screen:drawing()
	local width, height = self.width, self.height
	local scale = window:getScale()
		
	love.graphics.setColor(0.1, 0.1, 0.1, 1)
	love.graphics.rectangle('fill', 0, 0, width, height)
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(self.font)
	love.graphics.print('> '..terminal.inputText, 10 * window.scaleW, 70 * window.scaleH)
	
	local fontHeight = self.font:getHeight()
	for n = #terminal.history, 1, - 1 do
		local line = terminal.history[n]
		local y = (70 * window.scaleH) - (fontHeight * n)
		love.graphics.print(line, 10 * window.scaleW, y)
	end
	
	love.graphics.setLineWidth(4 * scale)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle('line', 0, 0, width, height)
end

function terminal:rescale()
	self.screen.font = love.graphics.newFont(12 * window:getScale())
end

terminal.screen = Screen:new(screen)

return terminal
