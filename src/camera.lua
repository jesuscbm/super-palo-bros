local assets = require("src.assets")
local bgLayers = {
	-- { image = assets.imgs["bg"], speed = 0.5 },
	{ image = assets.imgs["sky"], speed = 0.5 },
	{ image = assets.imgs["clouds"], speed = 0.7 },
}

local cam = {
	x = 0,
	y = 0,
}

function cam:set(x, y)
	self.x, self.y = x, y
end

function cam:apply()
	local x, y
	love.graphics.push()
	if self.y < 0 then
		if self.y > -400 then
			y = (self.y - love.graphics.getHeight() / 2) * self.y / 400 -- Makes the transformation linearly smooth
		else
			y = -self.y + love.graphics.getHeight() / 2
		end
	else
		y = 0
	end

	if self.x < love.graphics.getWidth() / 2 then
		-- Cannot go back
		x = 0
	else
		x = -self.x + love.graphics.getWidth() / 2
	end
	love.graphics.translate(x, y)

	-- Background with parallax that tiles in a 3x3, support for multilayer
	for _, bg in ipairs(bgLayers) do
		local imW, imH = bg.image:getWidth(), bg.image:getHeight()
		local indexX, indexY = math.floor(-x / imW), math.floor(-y / imH)
		local offsetX, offsetY = -x * bg.speed % imW, -y * bg.speed % imH
		for i = -1, 1, 1 do
			for j = -1, 1, 1 do
				love.graphics.draw(bg.image, (indexX + i) * imW + offsetX, (indexY + j) * imH + offsetY)
			end
		end
	end
end

function cam:clear()
	love.graphics.pop()
end

return cam
