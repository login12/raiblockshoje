dofile('data/lib/_woe.lua')

function onStepIn(player, item, position, fromPosition)

	local player = Player(cid)
	if not player then
		return true
	end
	
	local guild = player:getGuild()
	if item.actionid == Castle.tiles then
		Woe.getInfo()
		if player then
			if Woe.isTime() then
				if guild:guildId() ~= 0 then
					if Woe.isRegistered(player) then
						player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Good Luck ".. player:getName() .."!.")
					else
						Woe.moveBack(player, fromPosition, "you are not registered use !guild")
					end			
				else
					Woe.moveBack(player, fromPosition, "only players with guild can enter.")
				end
			elseif getPlayerGuildId(player) == infoLua[2] then
				if Woe.isRegistered(player) then
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "wellcome ".. player:getName() ..".")
				else
					Woe.moveBack(player, fromPosition, "you are not registered use !guild")
				end			
			else
				Woe.moveBack(player, fromPosition, "its not woe time and you are not member of ".. Woe.guildName() ..".")
			end
		end
	elseif item.actionid == Castle.portals then
		doTeleportThing(player, Castle.PreToPos[math.random(1, 2)], false)
	elseif item.actionid == Castle.bases then
		if player then
			Woe.moveBack(player, fromPosition, "you cant step there.")
		end
	end
	return true
end
