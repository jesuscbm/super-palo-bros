local p = {}

function p.beginContact(a, b, coll)
	if
		a:getUserData() == "player" and b:getUserData() == "brick"
		or b:getUserData() == "player" and a:getUserData() == "brick"
	then
		Game.current.player.grounded = true
		Game.current.player.state = "idle"
	end
end

function p.endContact(a, b, coll) end

return p
