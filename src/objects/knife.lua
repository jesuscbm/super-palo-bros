local object = require("src.objects.object")
local assets = require("src.assets")
local knife = object:extend()

function knife:init(world, x, y)
	self.width = 40
	self.height = 40

	self.destroyed = false

	self.name = "knife"
	self.image = assets.imgs["knife"]
	self.frame = 0
	self.n_frames = 8
	self.frameTimer = 0
	self.frameDuration = 0.1
	self.quads = {
		love.graphics.newQuad(0, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width * 1, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width * 2, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width * 3, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width * 4, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width * 5, 0, self.width, self.height, self.image),
		love.graphics.newQuad(self.width * 6, 0, self.width, self.height, self.image),
	}
	self.body = love.physics.newBody(world, x + self.width / 2, y + self.height / 2, "dynamic")
	self.body:setBullet(true)
	self.shape = love.physics.newCircleShape(self.width/2)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setFriction(0)
	self.fixture:setSensor(true)
	self.fixture:setUserData(self)
end

function knife:update(dt)
	if self.destroyed then
		return
	end
	self.frameTimer = self.frameTimer + dt
	if self.frameTimer > self.frameDuration then
		self.frame = (self.frame + 1) % self.n_frames
		self.frameTimer = self.frameTimer - self.frameDuration
	end
end

function knife:draw()
	if self.destroyed then
		return
	end
	local x, y = self.body:getPosition()
	love.graphics.draw(self.image, self.quads[self.frame + 1], x - self.width / 2, y - self.height / 2)

	-- love.graphics.circle("line", x, y, self.shape:getRadius())
end

function knife:destroy()
	self.destroyed = true
	self.body:destroy()
	self.fixture:destroy()
end

return knife
