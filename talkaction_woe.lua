function onSay(player, words, param)

	if words == "/woe" and param == "setup" then
		Woe.setup()
		return true
	end	
		
	------------------------------------------------------
	Woe.getInfo()	                                    --
	local myTable = {}	                                --
	for _, i in ipairs({"%d", "%B", "%Y", "%X"}) do     --  Don't change anything!
		table.insert(myTable, os.date(i, infoLua[4]))   --
	end                                                 --
	------------------------------------------------------
		
	if Woe.isStarted() then
		text = "Time left = " ..  Woe.timeToEnd().mins .. ":" .. Woe.timeToEnd().secs .. "\nActually the castle " .. Castle_name .. " is owned by " .. Woe.guildName() .. ".\n" .. Woe.breakerName() .. " broke the empe at "..myTable[1].." / "..myTable[2].." / "..myTable[3].." at time "..myTable[4].."."
	else
		text = "The last woe was won by " .. Woe.guildName() .. ".\n" .. Woe.breakerName() .. " broke the empe at "..myTable[1].." / "..myTable[2].." / "..myTable[3].." at time "..myTable[4].."."
	end
	
	if words == "/woe" then
		if player:getGroup():getId() >= accessToStar then
			if param == "on" then
				if Woe.isTime() ~= true then
					Game.broadcastMessage("(*) War of Emperium will start in next 5 minutes...", bcType)
					Game.broadcastMessage("will have a duration of " .. timeToEnd .. " minutes.", bcType)
					Game.setStorageValue(stor_WoeTime, 1)
				else
					player:sendCancelMessage("Event war of emperium is already running!")
				end
			elseif param == "off" then
				if Woe.isTime() == true then
					Game.broadcastMessage("(*) War of Emperium was canceled...", bcType)
					Game.setStorageValue(stor_WoeTime, 0)
					Game.setStorageValue(stor_Started, 0)
					checkMonster(Castle_empePos, 'Emperium')
					local tile = Tile(Position(Castle_desde)):getItemById(Castle_teleport)
					if tile then
						tile:remove()
						Position(Castle_desde):sendMagicEffect(CONST_ME_POFF)
					end
				else
					player:sendCancelMessage("Event war of emperium is not running...")
				end
			else
				player:sendCancelMessage("This is not valid param!")
			end
		elseif player:getGroup():getId() < accessToStar then
			if param == "info" then
				player:popupFYI(text)
			end
		else
			player:sendCancelMessage("This is not possible.")
		end
	end
		
	
	return true
end
