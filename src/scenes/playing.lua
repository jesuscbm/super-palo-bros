local player = require("src.objects.player")
local cam = require("src.camera")
local p = require("src.collisions")

local playing = {
	-- Obstacles, platforms, player, enemies...
}

function playing:load()
	playing.world = love.physics.newWorld(0, 30 * 64, true)

	playing.world:setCallbacks(p.beginContact, p.endContact)

	playing.player = player:new(playing.world)
	playing.bricks = require("src.loadbricks")
end

function playing:update(dt)
	playing.world:update(dt)
	playing.player:update(dt)
	local x, y = playing.player.body:getPosition()
	cam:set(x, y)
end

function playing:draw()
	cam:apply()
	playing.player:draw()
	for _, b in ipairs(playing.bricks) do
		b:draw()
	end
	cam:clear()
end

function playing:keypressed(key)
	if key == "escape" or key == "q" then
		love.event.push("quit")
	end
end

return playing
