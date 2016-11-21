dofile('data/lib/_woe.lua')

function onStepIn(cid, item, position, fromPosition)

	local player = Player(cid)
	if not player then
		return true
	end
	
	local guild = player:getGuild()
	if item.actionid == 3131 then
		Woe.getInfo()
		if player then
		print("OI")
			--if Woe.isTime() then
				--if guild:getId() ~= 0 then
					if Woe.isRegistered() then
						player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Good Luck ".. player:getName() .."!.")
					else
						Woe.moveBack(player, fromPosition, "you are not registered use !guild")
					end			
				--end
			--end
		end
	end	
	return true
end

function onAddItem(moveitem, tileitem, position)
	doRemoveItem(moveitem.uid, moveitem.type > 0 and moveitem.type or 1)
	return true
end
