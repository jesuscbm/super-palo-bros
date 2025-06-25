local assets = require("src.assets")
local object = require("src.objects.object")
local mill = object:extend()

function mill:init(world, x, y)
	self.width = 120
	self.height = 120

	self.name = "mill"

	self.destroyed = false

	self.body = love.physics.newBody(world, x + self.width / 2, y + self.height / 2, "dynamic")
	self.body:setFixedRotation(true)
	self.shape = love.physics.newPolygonShape(
		-self.width / 2 + 10,
		self.height / 2 - 15,
		-self.width / 2 + 15,
		self.height / 2,
		self.width / 2 - 15,
		self.height / 2,
		self.width / 2 - 10,
		self.height / 2 - 15,
		self.width / 2 - 10,
		-self.height / 2,
		-self.width / 2 + 10,
		-self.height / 2
	)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)

	self.orientation = 1 -- 1 for right, -1 for left
	self.orientationTimer = 0
	self.orientationDuration = 0.5

	-- Sides
	self.shapeLeftSide = love.physics.newRectangleShape(-self.width / 2 + 10, 0, 10, 20 )
	self.fixtureLeftSide = love.physics.newFixture(self.body, self.shapeLeftSide)
	self.fixtureLeftSide:setSensor(true)
	self.fixtureLeftSide:setUserData({ name = "millLeftSide", mill = self })
	self.shapeRightSide = love.physics.newRectangleShape(self.width / 2 - 10, 0, 10, 20)
	self.fixtureRightSide = love.physics.newFixture(self.body, self.shapeRightSide)
	self.fixtureRightSide:setSensor(true)
	self.fixtureRightSide:setUserData({ name = "millRightSide", mill = self })

	self.image = assets.imgs["mill"]
end

function mill:draw()
	if self.body:isDestroyed() then
		self.destroyed = true
		return
	end
	local x, y = self.body:getPosition()
	love.graphics.draw(self.image, x - self.width / 2, y - self.height / 2)

	-- Debug
	-- love.graphics.polygon("fill", self.body:getWorldPoints(self.shapeRightSide:getPoints()))
	-- love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
	-- love.graphics.polygon("fill", self.body:getWorldPoints(self.shapeLeftSide:getPoints()))
end

function mill:update(dt)
	if self.destroyed then
		self.destroyed = true
		return
	end
	local _, vy = self.body:getLinearVelocity()
	local speed = 200

	if self.orientationTimer > 0 then
		self.orientationTimer = self.orientationTimer - dt
	end

	self.body:setLinearVelocity(self.orientation * speed, vy)
end

function mill:flip() -- used in collision
	if self.orientationTimer > 0 then
		return
	end

	self.orientation = -self.orientation
	self.orientationTimer = self.orientationDuration
end

function mill:destroy()
	self.destroyed = true
	self.body:destroy()
	self.fixture:destroy()
end

return mill
