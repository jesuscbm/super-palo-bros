local object = require("src.objects.object")
local platform = object:extend()

function platform:init(world, name, x, y, width, height)
	self.width = width
	self.height = height

	self.body = love.physics.newBody(world, x, y, "static")
	self.shape = love.physics.newRectangleShape(width, height)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(name)

	return self
end

function platform:draw()
	local x, y = self.body:getPosition()
	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle("fill", x - self.width / 2, y - self.height / 2, self.width, self.height)
end

return platform
