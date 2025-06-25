local win = {}

function win:load()
end

function win:update(dt)
end

function win:draw()
	love.graphics.setBackgroundColor(0.6, 0.2, 1)
	love.graphics.print("You Win", 350, 500)
end

function win:keypressed(key)
	if key == "escape" or key == "q" then
		love.event.push("quit")
	end
end

return win
