local lose = {}

function lose:load()
    
end

function lose:update(dt)
end

function lose:draw()
	love.graphics.setBackgroundColor(0.6, 0.2, 1)
	love.graphics.print("You lost", 350, 500)
end

function lose:keypressed(key)
	if key == "escape" or key == "q" then
		love.event.push("quit")
	end
end

return lose
