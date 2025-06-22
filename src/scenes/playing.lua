local player = require("src.objects.player")
local cam = require("src.camera")

local playing = {
	-- Obstacles, platforms, player, enemies...
}

function playing:load()
	playing.world = love.physics.newWorld(0, 30 * 64, true)

	playing.player = player:new(playing.world)
	local elements = require("src.loadmap")
	if elements == nil then
                return nil	-- TODO: Error
	end
	playing.bricks = elements.bricks
	playing.cheese = elements.cheese
	playing.mills = elements.mills
	playing.knifes = {}

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
	for _, m in pairs(playing.mills) do
                m:update(dt)
        end
	local x, y = playing.player.body:getPosition()
	cam:set(x, y)
end

function playing:draw()
	cam:apply()
	playing.player:draw()
	for i, b in ipairs(playing.bricks) do
		if b.destroyed then
			table.remove(playing.bricks, i)
			goto continue
                end
		b:draw()
	    ::continue::
	end
	for _, m in pairs(playing.mills) do
		if m.destroyed then
                        goto continue
                end
                m:draw()
            ::continue::
        end	-- TODO: Drawable object they all extend??
	for _, c in pairs(playing.cheese) do
                c:draw()
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
