local assets = require("src.assets")
local menu = {
	-- Text, buttons, ...
}

function menu:load()
	self.title = assets.imgs["title"]
end

function menu:update(_)
	if love.keyboard.isDown("space") then
		Game.current = Game.playing
		Game.current:load()
	end
end

function menu:draw()
	love.graphics.draw(self.title, 800 / 2 - self.title:getWidth() / 2, 0)
	love.graphics.print("Press Space to start", 350, 500)
	love.graphics.setBackgroundColor(0.6, 0.2, 1)
end

function menu:keypressed(key)
	if key == "escape" or key == "q" then
		love.event.push("quit")
	end
end

return menu
