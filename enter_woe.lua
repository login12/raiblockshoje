-- by login12
-- fb.com.br/overflaw

function onStepIn(player, item, position, fromPosition)

	if not player then
		return true
	end
	
	local guild = player:getGuild()
		if item.actionid == Castle_tiles then
			Woe.getInfo()
			if player then
				if Woe.isTime() then
					if guild ~= nil then
						if isRegistered then
							player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Good Luck ".. player:getName() .."!")
						else
							player:teleportTo(fromPosition)
							player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You are not registered use !guild for register yourself.")
							fromPosition:sendMagicEffect(CONST_ME_POFF)
						end
					else
						player:teleportTo(fromPosition)
						player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You need guild to participate in this event.")
						fromPosition:sendMagicEffect(CONST_ME_POFF)
					end
				else
					if Woe.guildName() == "Nones" then
						player:teleportTo(fromPosition)
						player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Its not War of Emperium time and noone have dominate the castle at now.")
						fromPosition:sendMagicEffect(CONST_ME_POFF)
						return false
					end				
					player:teleportTo(fromPosition)
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Its not War of Emperium time and you are not member of "..Woe.guildName().." for enter here.")
					fromPosition:sendMagicEffect(CONST_ME_POFF)
				end
			end	
			elseif item.actionid == Castle_portals then
				player:teleportTo(Castle_PreToPos[math.random(1, 2)], false)
			elseif item.actionid == Castle_bases then
				if player then
					player:teleportTo(fromPosition)
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You can't step there!")
					fromPosition:sendMagicEffect(CONST_ME_POFF)
				end	
			end
	return true
end
