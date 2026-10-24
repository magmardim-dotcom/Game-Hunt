local Screen = require 'screen'

local Text = class:new(Screen)

local function replase(str, vars)
	local res
	res = str:gsub(
		"%[([%w_]+)%]", 
		function(key)    
			return vars[key] or "[" .. key .. "]"
		end)
	return res
end

local function parse(str, bc)
	local res = {}
	local startpos = 1
	local color = bc or nil
	
	while true do
		local finalpos = str:find('%%', startpos)		
		if finalpos == nil then 			
			table.insert(res, {color, string.sub(str, startpos)}) 
			break 
		end
		table.insert(res, {color, string.sub(str, startpos, finalpos-1)})
		
		local open = finalpos + 1
		local close = str:find('}', open) 
		if not open or not close then break end
		
		local i = str:sub(open + 1, close - 1)
		
		local newcolor = {}		
		for t in string.gmatch(i, "[^,]+") do
			t = t:match("^%s*(.-)%s*$") 
			table.insert(newcolor, tonumber(t))
		end
		color = newcolor
		startpos = close + 1		
	end
	
	return res
end

local function wrapcoloredtext(coloredtext, self)
	local wraptext = {}
	local line = {}
	local textwidth = self.width - self.marginX
	local currwidth = 0
	local idx = 1
	
	while idx < #coloredtext do
		local color = coloredtext[idx] 
		local text = coloredtext[idx + 1] 		
		local wrapedtext = select(2, self.font:getWrap(text, textwidth - currwidth))
		
		idx = idx + 2
		
		for n = 1, #wrapedtext do
			local w = wrapedtext[n]
			local wlen = self.font:getWidth(w)
			if #line == 0 or (currwidth + wlen < textwidth) then
				currwidth = currwidth + wlen 
				line[#line + 1] = color
				line[#line + 1] = w
			else
				wraptext[#wraptext + 1] = line
				line = {color, w}
				currwidth = wlen
			end
			
		end
		
		
	end
	wraptext[#wraptext + 1] = line	
	
	return wraptext
end

function refresh(self, rstr)
	if rstr then 
		self.text:clear()
		local str = replase(rstr, self)			
		local p = parse(str, self.text_color)
		
		local coloredtext = {}
		for _, v in ipairs(p) do
			table.insert(coloredtext, v[1])		
			table.insert(coloredtext, v[2])		
		end
		local wraptext = wrapcoloredtext(coloredtext, self)
		
		for n = 1, #wraptext - 1 do
			self.text:addf(wraptext[n], self.width - self.marginX, self.align, 0, (n-1) * self.font:getHeight())
		end
		self.text:addf(wraptext[#wraptext], self.width - self.marginX, self.align == 'justify' and 'left' or self.align, 0, (#wraptext-1) * self.font:getHeight())
	end		
end

function Text:new(o)
    local o = o or {}
        
	o.x = o.x or 0
	o.y = o.y or 0
	o.width = o.width or error("the Text width is not set")		
	o.height = o.height or error("the Text height is not set")
	o.font = o.font or self.__defaults.font
    o.text = love.graphics.newText(o.font)
    o.string = ''
    
    return self.__create(o)
end

function Text:drawing() 
	love.graphics.push()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(self.text, self.marginX, self.marginY)
	love.graphics.pop()
end

function Text:setText(text)
	if text then
		refresh(self, text)
		self.string = text	
	end	
	return self
end

function Text:setFont(font)
	self.font = font
	self.text:setFont(self.font)
	
	if self.string ~= '' then
		refresh(self, self.string)
	end
	
	return self
end


return Text
