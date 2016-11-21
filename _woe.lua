dofile('data/lib/var.woe')

local config = woe_config

fileStore = true
stor.register = 8589
infoFile = 'tmp.woe'
infoLua = {}

Woe = {}
Woe.__index = Woe

function Woe.setup()
	db.executeQuery("DROP TABLE IF EXISTS `woe`;")
	db.executeQuery("CREATE TABLE `woe` (`id` INT( 11 ) NOT NULL AUTO_INCREMENT ,`started` INT( 11 ) NOT NULL ,`guild` INT( 11 ) NOT NULL ,`breaker` INT( 11 ) NOT NULL ,`time` INT( 11 ) NOT NULL ,PRIMARY KEY ( `id` ) ,UNIQUE (`id`)) ENGINE = MYISAM")
	if fileStore then
		local newFile = io.open(infoFile, "w")
		for _, i in ipairs({'started', 'guild', 'breaker', 'time'}) do
			newFile:write(i .. ' = 0 ;end;\n')
		end
		newFile:close()
	else
		db.executeQuery("DROP TABLE IF EXISTS `tmpwoe`;")
		db.executeQuery("CREATE TABLE `tmpwoe` (`started` INT( 11 ) NOT NULL ,`guild` INT( 11 ) NOT NULL ,`breaker` INT( 111 ) NOT NULL ,`time` INT( 1 ) NOT NULL) ENGINE = MYISAM ;")
		db.executeQuery("ALTER TABLE `tmpwoe` ADD `indexer` INT NOT NULL ")
		db.executeQuery("INSERT INTO `tmpwoe` (`started` ,`guild` ,`breaker` ,`time`, `indexer`)VALUES ('0', '0', '0', '0', '1');")
	end
end

function Woe.getInfo()
	if fileStore then
		local open = io.open(infoFile, "r")
		if open then
			for i in io.lines(infoFile) do 
				for v, k in ipairs({'started', 'guild', 'breaker', 'time'}) do
					if (i:find(k)) then
						n = i:match(k .. '.*')
						infoLua[v] = tonumber(n:sub(n:find('=') + 2, n:find(';end;') - 2))
					end
				end
			end
			open:close()
		end
	else
		for v, k in ipairs({'started', 'guild', 'breaker', 'time'}) do
			local tmp = db.getResult("SELECT " .. k .. " FROM `tmpwoe` WHERE `indexer` = '1';")
			infoLua[v] = tmp:getDataInt(k)
			tmp:free()
		end
	end
end

function Woe.updateInfo(tab)
	if fileStore then
		local open = io.open(infoFile, "w")
		if open then
			for k, i in ipairs({'started', 'guild', 'breaker', 'time'}) do
				open:write(i .. ' = ' .. tab[k] .. ' ;end;\n')
			end
			open:close()
		end
	else
		for v, k in ipairs({'started', 'guild', 'breaker', 'time'}) do
			db.executeQuery("UPDATE `tmpwoe` SET " .. k .. " =  " .. tab[v] .. " WHERE `indexer` = 1;")
		end
	end
end

function Woe.save()
	Woe.getInfo()
	db.executeQuery("INSERT INTO `woe` (`started`, `guild`, `breaker`, `time`) VALUES (" .. infoLua[1] .. ", " .. infoLua[2] .. ", " .. infoLua[3] .. ", " .. infoLua[4] .. ");")
end

function Woe.getGuildName(id)
	local res = db.getResult("SELECT `name` FROM `guilds` WHERE `id` = " .. id .. ";")
	if (res:getID() ~= -1) then
		ret = res:getDataString('name')
		res:free()
	end
	return ret
end

function Woe.breakerName()
	Woe.getInfo()
	return infoLua[3] ~= 0 and getPlayerNameByGUID(infoLua[3]) or 'None'
end

function Woe.guildName()
	Woe.getInfo()
	return infoLua[2] ~= 0 and Woe.getGuildName(infoLua[2]) or 'Nones'
end

function Woe.startTime()
	Woe.getInfo()
	return os.date("%d %B %Y %X ", infoLua[1])
end

function Woe.breakTime()
	Woe.getInfo()
	return os.date("%d %B %Y %X ", infoLua[4])
end

function Woe.timeToEnd()
	Woe.getInfo()
	local myTable = {}
	for k, i in ipairs({"%M", "%S"}) do
		myTable[k] = os.date(i, os.difftime(os.time(), infoLua[1]))
	end
	return {mins = ((config.timeToEnd - 1) - myTable[1]), secs = (60 - myTable[2])}
end

function Woe.moveBack(player, fromPosition, text)
	player:teleportTo(fromPosition, true)
	player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You cant move for here.')
end

function Woe.getGuildMembers(player, id)
local players = Game.getPlayers()
local i = db.getResult('select `guild` from id where name = \''..players..'\'')
local members = {}

  if id == i then
   table.insert(members, i)
  end

 return members
end

function Woe.deco(text)
	for _, i in ipairs(Castle.decoraciones) do
		item:setAttribute(i, "description", text)
	end
end

function Woe.removePortals()
	for _, i in ipairs(Castle.PrePortalsPos) do
		if (getThing:fromPosition(i).itemid > 0) then
			item:remove(getThing:fromPosition(i).uid)
		end
	end
end

function Woe.removePre()
	for _, i in ipairs(Castle.PreEmpes) do
		if (creature:isCreature(getThing:fromPosition(i).uid) == true) then
			creature:remove(getThing:fromPosition(i).uid)
		end
	end
end

function Woe.checkPre()
	local Count = 0
	for _, i in ipairs(Castle.PreEmpes) do
		if (creature:isCreature(getThing:fromPosition(i).uid) == false) then
			Count = Count + 1
		end
	end
	return (Count == #Castle.PreEmpes)
end

function Woe.isTime()
	return (Game.getStorageValue(stor.WoeTime) == 1)
end

function Woe.isStarted()
	return (Game.getStorageValue(stor.Started) == 1)
end

function Woe.isRegistered(player)

	if player:getStorage(8589) == 1 then
	player:toTeleport(31783, 31936, 7)
	else
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "you are not registered use !guild")
	end
	return true
end

function Woe.isInCastle(player)
	local myPos = player:getPosition()
	if (myPos.x >= Castle.salas.a.fromx and myPos.x <= Castle.salas.a.tox) then
		if (myPos.y >= Castle.salas.a.fromy and myPos.y <= Castle.salas.a.toy) then
			if isInArray({Castle.salas.a.z, Castle.salas.b.z, Castle.salas.c.z}, myPos.z) then
				return true
			end
		end
	end
	return false
end

function Woe.expulsar(guild, fromx, tox, fromy, toy, z, outpos)
	for _x = fromx, tox do
		for _y = fromy, toy do
			local player = getThingFromPos({x = _x, y = _y, z = z, stackpos = 253}).uid
			if (isPlayer(player) == true) then
				if (getPlayerGuildId(player) ~= guild) then
					doTeleportThing(player, outpos, false)
				end
			end
		end
	end
end

-- extras

function doSetItemActionId(uid, action)
	item:setAttribute(uid, "aid", action)
end

function exhaust(player, storevalue, exhausttime)
-- Exhaustion function by Alreth, v1.1 2006-06-24 01:31
-- Returns 1 if not exhausted and 0 if exhausted
    newExhaust = os.time()
    oldExhaust = player:getStorageValue(storevalue)
    if (oldExhaust == nil or oldExhaust < 0) then
        oldExhaust = 0
    end
    if (exhausttime == nil or exhausttime < 0) then
        exhausttime = 1
    end
    diffTime = os.difftime(newExhaust, oldExhaust)
    if (diffTime >= exhausttime or diffTime < 0) then
        player:setStorageValue(storevalue, newExhaust) 
        return 1
    else
        return 0
    end
end

--new
guard_pos = 
	{
		{x = 55, y = 31, z = 5},
		{x = 55, y = 30, z = 5},
		{x = 55, y = 29, z = 5},
		{x = 55, y = 28, z = 5},
		{x = 55, y = 27, z = 5},
		{x = 55, y = 26, z = 5},
		{x = 55, y = 25, z = 5}
	}
	
function Woe.check()
	for storage = 24504, 24511 do
		local pid = Game.getStorageValue(storage)
		if isCreature(pid) then
			return false
		end
	end
	return true
end

function Woe.summon()
	for k, i in ipairs(guard_pos) do
		local pid = Game.getStorageValue("guard", i)
		Game.setStorageValue(24503 + k, pid)
	end
end

function Woe.remove()
	for storage = 24504, 24511 do
		local pid = Game.getStorageValue(storage)
		if isCreature(pid) then
			creature:remove(pid)
		end
	end
end
