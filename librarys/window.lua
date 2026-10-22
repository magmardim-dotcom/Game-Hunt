local getDimensions = love.graphics.getDimensions

local window = {
	defWidth = 800,
	defHeight = 600,
	scaleWidth = 2,
	scaleHeight = 1,
}

function window:getFontScale()
	return math.max(self.scaleWidth, self.scaleHeight)
end

function window:refreshScale(newW, newH)
	local winW, winH = getDimensions()
	
    self.scaleW = newW / self.defWidth
    self.scaleH = newH / self.defHeight
    
    return self.scaleW,  self.scaleH
end


return window
