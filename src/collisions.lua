local p = {}
local player = Game.current.player

function p.beginContact(a, b, coll)
	if
		a:getUserData() == "feet" and b:getUserData() == "brick"
		or b:getUserData() == "feet" and a:getUserData() == "brick"
	then
		player.feetContacts = player.feetContacts + 1
		if player.isGrounded() then
			player.state = "idle"
		end
	end

	if a:getUserData() == "knife" and b:getUserData() == "brick" then
		a:getBody():destroy()
	elseif b:getUserData() == "knife" and a:getUserData() == "brick" then
                b:getBody():destroy()
	end
end

function p.endContact(a, b, coll)
	if
		a:getUserData() == "feet" and b:getUserData() == "brick"
		or b:getUserData() == "feet" and a:getUserData() == "brick"
	then
		player.feetContacts = player.feetContacts - 1
		if not player.isGrounded() then
			player.state = "jump"
		end
	end
end
return p
