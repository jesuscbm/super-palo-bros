local player = require("src.objects.player")
local knife = require("src.objects.knife")
local cam = require("src.camera")

local playing = {
	-- Obstacles, platforms, player, enemies...
}

function playing:load()
	playing.world = love.physics.newWorld(0, 30 * 64, true)

	playing.player = player:new(playing.world)
	playing.bricks = require("src.loadbricks")
	playing.knifes = {
		knife:new(playing.world, 0, 0),
	}

	local p = require("src.collisions")
	playing.world:setCallbacks(p.beginContact, p.endContact)
end

function playing:update(dt)
	playing.world:update(dt)
	playing.player:update(dt)
	for i, k in pairs(playing.knifes) do
		if k.destroyed then
            table.remove(playing.knifes, i)
        end
        k:update(dt)
    end
	local x, y = playing.player.body:getPosition()
	cam:set(x, y)
end

function playing:draw()
	cam:apply()
	playing.player:draw()
	for _, b in pairs(playing.bricks) do
		b:draw()
	end
    for _, k in pairs(playing.knifes) do
        k:draw()
    end
	cam:clear()
end

function playing:keypressed(key)
	if key == "escape" or key == "q" then
		love.event.push("quit")
	end
end

return playing
