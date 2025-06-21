local assets = require("src.assets")
local object = require("src.objects.object")
local player = object:extend()
local knife = require("src.objects.knife")

-- TODO: Acceleration?
function player:init(world)
	self.facing = 1 -- 1 for right, -1 for left
	self.width = 128
	self.height = 180

	self.coyoteTime = 0.15
	self.coyoteTimer = 0

	self.jumpBufferTime = 0.15
	self.jumpBufferTimer = 0

	self.body = love.physics.newBody(world, 200, 180, "dynamic")
	self.body:setFixedRotation(true)
	self.shape = love.physics.newRectangleShape(self.width - 20, self.height) -- We make it a bit thinner to have a forgiving hitbox
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData("player")
	-- For the feet
	self.feetShape = love.physics.newRectangleShape(0, self.height / 2, self.width - 40, 10)
	self.feetFixture = love.physics.newFixture(self.body, self.feetShape)
	self.feetFixture:setSensor(true) -- Just senses doesn't collide
	self.feetFixture:setUserData("feet")

	self.feetContacts = 0
	self.isGrounded = function()
		return self.feetContacts > 0
	end

	-- For the head
	self.headShape = love.physics.newRectangleShape(0, -self.height / 2, self.width - 40, 10)
	self.headFixture = love.physics.newFixture(self.body, self.headShape)
	self.headFixture:setSensor(true)
	self.headFixture:setUserData("head")

	self.image = assets.imgs["sprite"]
	self.frames = {
		idle = {
			frame = 0,
			frames = {
				love.graphics.newQuad(0, 0, self.width, self.height, self.image),
			},
		},
		run = {
			duration = 0.2, -- per frame
			currentTime = 0,
			frame = 0,
			n_frames = 4,
			frames = {
				love.graphics.newQuad(self.width * 1, 0, self.width, self.height, self.image), -- TODO: Quad bleeds
				love.graphics.newQuad(self.width * 2, 0, self.width, self.height, self.image),
				love.graphics.newQuad(self.width * 3, 0, self.width, self.height, self.image),
				love.graphics.newQuad(self.width * 4, 0, self.width, self.height, self.image),
			},
		},
		jump = {
			frame = 0,
			frames = {
				love.graphics.newQuad(self.width * 5, 0, self.width, self.height, self.image),
			},
		},
	}
	self.state = "idle"

	self.throw = {}
	self.throw.timer = 0
	self.throw.maxTimer = 1

	return self
end

function player:draw()
	local x, y = self.body:getPosition()
	local quad = self.frames[self.state].frames[self.frames[self.state].frame + 1]

	love.graphics.draw(
		self.image,
		quad,
		x,
		y, -- position
		0, -- rotation
		self.facing, -- scaleX: 1 or -1
		1, -- scaleY
		self.width / 2, -- origin X
		self.height / 2 -- origin Y
	)

	if self.throw.timer > 0 then
		local rWidth, rHeight = 128, 15
		love.graphics.rectangle("line", x - rWidth / 2, y - rHeight / 2 - self.height / 2, rWidth, rHeight)
		love.graphics.rectangle(
			"fill",
			x - rWidth / 2,
			y - rHeight / 2 - self.height / 2,
			self.throw.timer / self.throw.maxTimer * rWidth,
			rHeight
		)
	end

	-- Debug
	-- love.graphics.polygon("fill", self.body:getWorldPoints(self.feetShape:getPoints()))
	-- love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
	-- love.graphics.polygon("fill", self.body:getWorldPoints(self.headShape:getPoints()))
end

function player:update(dt)
	local vx, vy = self.body:getLinearVelocity()
	local speed = 200

	-- Animations
	local run = self.frames.run
	run.currentTime = run.currentTime + dt
	if run.currentTime > run.duration then
		run.currentTime = run.currentTime - run.duration
		run.frame = (run.frame + 1) % run.n_frames
	end

	-- Coyote Time
	if not self.isGrounded() then
		self.coyoteTimer = self.coyoteTimer + dt
	else
		self.coyoteTimer = 0
	end

	-- Jump Buffer
	self.jumpBufferTimer = self.jumpBufferTimer + dt
	if self.isGrounded() and self.jumpBufferTimer <= self.jumpBufferTime then
		self.body:applyLinearImpulse(0, -6500)
	end

	-- Keys
	if love.keyboard.isDown("left") then -- Consider keypressed
		vx = -speed
		self.facing = -1
		if self.state == "idle" then
			self.state = "run"
		end
	elseif love.keyboard.isDown("right") then
		vx = speed
		self.facing = 1
		if self.state == "idle" then
			self.frames.run.frame = 0
			self.frames.run.currentTime = 0
			self.state = "run"
		end
	else
		vx = 0
		if self.state == "run" then
			self.frames.run.frame = 0
			self.frames.run.currentTime = 0
			self.state = "idle"
		end
	end

	self.body:setLinearVelocity(vx, vy)

	local x, y = self.body:getPosition()
	if x < self.width / 2 then
		self.body:setPosition(self.width / 2, y)
	end
	if love.keyboard.isDown("up") then
		local _, dy = self.body:getLinearVelocity()
		if (self.isGrounded() or self.coyoteTimer < self.coyoteTime) and dy >= -20 then
			self.body:applyLinearImpulse(0, -6500)
		end
		self.jumpBufferTimer = 0
	end
	if love.keyboard.isDown("space") then
		self.throw.timer = self.throw.timer + dt
		if self.throw.timer > self.throw.maxTimer then
			self.throw.timer = self.throw.maxTimer
		end
	else
		if self.throw.timer > 0 then
			local k = knife:new(Game.current.world, x + self.facing * self.width / 2, y)
			table.insert(Game.current.knifes, k)
			k.body:applyLinearImpulse(
				self.facing * 300 * (self.throw.timer / self.throw.maxTimer),
				-100 * (self.throw.timer / self.throw.maxTimer)
			)
			self.throw.timer = 0
		end
	end
end

return player
