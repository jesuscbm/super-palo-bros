local assets = require("src.assets")
local object = require("src.objects.object")
local player = object:extend()

-- TODO: Acceleration?
function player:init(world)
	self.facing = 1 -- 1 for right, -1 for left
	self.width = 128
	self.height = 180
	self.grounded = false

	self.body = love.physics.newBody(world, 200, 180, "dynamic")
	self.shape = love.physics.newRectangleShape(self.width, self.height)
	-- TODO: New fixture for feet?
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData("player")

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
	return self
end

function player:draw()
	local x, y = self.body:getPosition()
	local quad = self.frames[self.state].frames[self.frames[self.state].frame + 1]

	love.graphics.setColor(1, 1, 1)

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
	love.graphics.setColor(1, 1, 1)
end

function player:update(dt)
	local vx, vy = self.body:getLinearVelocity()
	local speed = 200

	local run = self.frames.run
	run.currentTime = run.currentTime + dt
	if run.currentTime > run.duration then
		run.currentTime = run.currentTime - run.duration
		run.frame = (run.frame + 1) % run.n_frames
	end

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
		if self.grounded then
			self.body:applyLinearImpulse(0, -6500)
			self.state = "jump"
			self.grounded = false
		end
	end
end

return player
