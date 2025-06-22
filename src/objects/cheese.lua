local object = require("src.objects.object")
local assets = require("src.assets")
local cheese = object:extend()

function cheese:init(world, x, y)
	self.width = 128
	self.height = 128

	self.name = "cheese"

	self.body = love.physics.newBody(world, x + self.width / 2, y + self.height / 2, "static")
	self.shape = love.physics.newCircleShape(self.width / 2)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)

	self.image = assets.imgs["cheese"]
end

function cheese:draw()
	local x, y = self.body:getPosition()
	love.graphics.draw(self.image, x - self.width / 2, y - self.height / 2)
end

return cheese
