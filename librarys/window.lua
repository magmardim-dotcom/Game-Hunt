local getDimensions = love.graphics.getDimensions

local window = {
	defWidth = 960,
	defHeight = 540,
	scaleW = 1,
	scaleH = 1,
}

function window:getScale()
	return math.max(self.scaleW, self.scaleH)
end

function window:refreshScale(newW, newH)
	local winW, winH = getDimensions()
	
    self.scaleW = newW / self.defWidth
    self.scaleH = newH / self.defHeight
    
    return self.scaleW,  self.scaleH
end


return window
