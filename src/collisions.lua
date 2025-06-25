local p = {}
local player = Game.current.player

function p.beginContact(a, b, coll)
	local aData = a:getUserData()
	local bData = b:getUserData()
	if aData.name == nil or bData.name == nil then
		return
	end

	-- feet-brick collision
	if aData.name == "feet" and bData.name == "brick" or bData.name == "feet" and aData.name == "brick" then
		player.feetContacts = player.feetContacts + 1	-- TODO: Not use global
		if player.isGrounded() and player.state == "jump" then
			player.state = "idle"
		end
	end

	-- knife-brick collision
	if aData.name == "knife" and bData.name == "brick" then
		aData:destroy()
	elseif bData.name == "knife" and aData.name == "brick" then
		bData:destroy()
	end

	-- head-brick collision
	if aData.name == "head" and bData.name == "brick" then
		bData:destroy()
	elseif bData.name == "head" and aData.name == "brick" then
		aData:destroy()
	end

	-- player-cheese collision
	if aData.name == "player" and bData.name == "cheese" or bData.name == "player" and aData.name == "cheese" then
		-- TODO: Win screen
		Game.current = Game.win
		Game.current:load()
	end

	-- player-mill collision

	if aData.name == "feet" and bData.name == "mill" then
		aData.player.invulnerabilityTimer = aData.player.invulnerabilityTime
		bData:destroy()
	end
	if bData.name == "feet" and aData.name == "mill" then
		bData.player.invulnerabilityTimer = bData.player.invulnerabilityTime
		aData:destroy()
	end

	if aData.name == "player" and bData.name == "mill" or bData.name == "player" and aData.name == "mill" then
		-- TODO: Death screen
		if aData.invulnerabilityTimer > 0 then
			return
		end
		Game.current = Game.lose
		Game.current:load()
	end


	-- mill-knife collision
	if aData.name == "mill" and bData.name == "knife" then
		aData:destroy()
	end
	if bData.name == "mill" and aData.name == "knife" then
		bData:destroy()
	end

	-- mill-wall collision
	if
		(aData.name == "brick" or aData.name == "millLeftSide" or aData.name == "millRightSide")
		and (bData.name == "millLeftSide" or bData.name == "millRightSide")
	then
		bData.mill:flip()
	end

	if
		(bData.name == "brick" or bData.name == "millLeftSide" or bData.name == "millRightSide")
		and (aData.name == "millLeftSide" or aData.name == "millRightSide")
	then
		aData.mill:flip()
	end
end

function p.endContact(a, b, coll)
    local aData = a:getUserData()
    local bData = b:getUserData()
	if
		aData.name == "feet" and bData.name == "brick"
		or bData.name == "feet" and aData.name == "brick"
	then
		player.feetContacts = player.feetContacts - 1
		if not player.isGrounded() then
			player.state = "jump"
		end
	end
end
return p
