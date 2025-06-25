local assets = require("src.assets")
local object = require("src.objects.object")
local brick = object:extend()

function brick:init(world, x, y)
	self.width = 128
	self.height = 128

	self.name = "brick"

	self.image = assets.imgs["brick"]
	self.body = love.physics.newBody(world, x + self.width / 2, y + self.height / 2, "static")
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setFriction(0)
	self.fixture:setUserData(self)

	self.destroyed = false

	return self
end

function brick:draw()
	if self.destroyed then
                return
        end
	local x, y = self.body:getPosition()
	love.graphics.draw(self.image, x - self.width / 2, y - self.height / 2)
end

function brick:destroy()
        self.destroyed = true
        self.body:destroy()
	self.fixture:destroy()
end

return brick
