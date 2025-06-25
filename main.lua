Game = {
    -- Scenes go here. Facilitates navigation
}

function love.load()
    love.graphics.setBackgroundColor(0.4, 0.8, 1)
    love.physics.setMeter(64)

    Game.menu = require("src.scenes.menu")
    Game.playing = require("src.scenes.playing")
	Game.win = require("src.scenes.win")
	Game.lose = require("src.scenes.lose")
    Game.current = Game.menu
    Game.current:load()
end

-- dt = delta time. To make the game frame rate independent
function love.update(dt)
    Game.current:update(dt)
end

function love.draw()
    Game.current:draw()
end

function love.keypressed(key)
    Game.current:keypressed(key)
end

