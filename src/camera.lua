local cam = { x = 0, y = 0 }

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
end

function cam:clear()
	love.graphics.pop()
end

return cam
