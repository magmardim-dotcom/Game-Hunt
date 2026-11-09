local getDimensions = love.graphics.getDimensions

local window = {
	defWidth = 960,
	defHeight = 540,
	scaleW = 1,
	scaleH = 1,
}

function window:getScale()
	return math.min(self.scaleW, self.scaleH)
	--~ return 1
end

function window:refreshScale(newW, newH)
	self.scaleW = newW / self.defWidth
    self.scaleH = newH / self.defHeight
    
    return self.scaleW,  self.scaleH
end

function window:setFullscreen()
	local bool = not love.window.getFullscreen()
	love.window.setFullscreen(bool)
	local winW, winH = getDimensions()
	self:refreshScale(winW, winH)
	return true
end


return window
