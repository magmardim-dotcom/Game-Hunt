local Screen = require 'screen'

local Menu = {}
Menu = class:new(Menu, Screen)
	
function Menu:new(o)
	local o = o or {}	
    
		o.x = o.x or 0
		o.y = o.y or 0
		o.item = o.item or 1	
		o.strings = o.strings or {}
		o.lmark = o.lmark or "["
		o.rmark = o.rmark or "]"
		o.width = o.width or error("the menu width is not set")
		local fontSize = (o.fontSize or self.__defaults.fontSize) * window:getFontScale()
		o.font = o.font or love.graphics.newFont(fontSize)
		o.height = o.height or #o.strings * (o.font or love.graphics.getFont()):getHeight()
		
	return self.__create(o)
end

function Menu:drawing()
	local color1 = self.text_color
	local color2 = self.text_color2
	
	love.graphics.push()
	love.graphics.setFont(self.font)
	
	for k, s in ipairs(self.strings) do
		Iselect = function(string)
			local nam = string
			
			if self.item == k then
				love.graphics.setColor(color2)
				nam = self.lmark..string..self.rmark
			else
				love.graphics.setColor(color1)
			end
			return nam
		end
		
		local fontH = self.font:getHeight()
		
		if s ~= nil then  
			if type(s.nam) == 'string' then
				love.graphics.printf(Iselect(s.nam), self.marginX, (fontH) * (k - 1), self.width, self.align)
			elseif type(s.nam) == 'function' then
				love.graphics.printf(Iselect(s.nam(self)), self.marginX, (fontH) * (k - 1), self.width, self.align)
			end
		end		
	end
	
	love.graphics.pop()
end

function Menu:update(dt)
	
end

function Menu:keypressed(key, down, up, left, right, restart)
	function skip(item, it, n)
		local it = it + n
		
		if it == 0 then
			return #self.strings
		end

		if item[it] == nil or item[it].skip then
			return skip(item, it, n)			
		else
			return it
		end
	end
	
	if key == down and self.item + 1 <= #self.strings then
		self.item = skip(self.strings, self.item, 1)
	elseif key == up and self.item - 1 >= 1 then
		self.item = skip(self.strings, self.item, -1) 
	end
	
	local s = self.strings[self.item]
	
	if s.act and key == restart then
		s.act(self)
	end
	
	if s.right and key == right then
		s.right(self)
	end
	
	if s.left and key == left then
		s.left(self)
	end
end

function Menu:setFont(size, fontFile)
	size = size or error("size is nil in function Menu:setFont")
	local newFont
	local newSize = size * window:getFontScale()
	
	if fontFile then
		newFont = love.graphics.newFont(fontFile, newSize)
	else
		if self.fontFile then
			newFont = love.graphics.newFont(self.fontFile, newSize)
		else
			newFont = love.graphics.newFont(newSize)
		end
	end
	self.fontFile = fontFile
	self.fontSize = size
	self.font = newFont
	
	return self
end

return Menu
