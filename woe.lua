local config = woe_config

Castle, woe_config, stor = {}, {}, {}

Castle_name = 'Matsumoto' --Name of castle
Castle_tiles = 3131 --Aid of entry
Castle_banderas = 3133 --Aid of flags on castle
Castle_decoraciones = {} --Uids in case you have decorations with info.
Castle_pos = {x = 55, y = 79, z = 7} --Where you teleported from temple.
Castle_exit = {x = 32369, y = 32241, z = 7} --Where players are teleported when finished or castle owner change.
Castle_desde = {x = 32369, y = 32235, z = 7, stackpos = 1}
default_map = true --If you will not use default map you should config all the pos.

Castle_empePos = {x = 55, y = 34, z = 5, stackpos = 253}

if default_map then
	local pos = Castle_empePos
	Castle_guildEntry = {x = pos.x - 9, y = pos.y + 4, z = pos.z} --Entry for guild by using flags.

	--Each floor should be all floor.
	Castle_salas =
		{
			a = {fromx = pos.x - 18, tox = pos.x + 18, fromy = pos.y - 10, toy =  pos.y + 28, z = pos.z + 2},
			b = {fromx = pos.x - 18, tox = pos.x + 18, fromy = pos.y - 10, toy =  pos.y + 28, z = pos.z + 1},
			c = {fromx = pos.x - 18, tox = pos.x + 18, fromy = pos.y - 10, toy =  pos.y + 28, z = pos.z}
		}
	
	--Pre empes pos.
	Castle_PreEmpes = 
		{
			{x = pos.x - 13, y = pos.y + 3, z = pos.z + 1, stackpos = 253}, 
			{x = pos.x + 13, y = pos.y + 3, z = pos.z + 1, stackpos = 253}
		}	
	
	--When you kill pre empes new portals appears.
	Castle_PrePortalsPos = 
		{
			{x = pos.x - 4, y =  pos.y - 6, z = pos.z + 1, stackpos = 1},
			{x = pos.x + 4, y =  pos.y - 6, z = pos.z + 1, stackpos = 1}
		}
		
	Castle_PreToPos = 
		{
			[1] = {x = pos.x - 7, y =  pos.y + 26, z = pos.z},
			[2] = {x = pos.x + 7, y =  pos.y + 26, z = pos.z}
		}
else
	return false		
end

woe_config.timeToEnd = 30 --Duration
woe_config.bcType = MESSAGE_EVENT_ADVANCE --Bc type
woe_config.dias = {"tuesday", "thursday", "saturday"} --Days
woe_config.horaPartida = 11 --Time to start
woe_config.accessToStar = 4 --Access to start
woe_config.recallTime = 3 * 60 --Recall delay
woe_config.premios = true --Rewards for winners
		
--{
Castle_portals = 3132 --Aid for created portals
Castle_bases = 3134 --Aid of empes bases
--}

stor_register = 8589 --Storage for register players
stor_recall = 23155
stor_WoeTime = 7802 --Global storage, about time of WoE (started or not)
stor_Started = 7801 --Global storage started

----------------------------
local config = woe_config --
fileStore = true		  --
infoFile = 'tmp.woe'      -- Dont change anything here! Just if you really know what you doing.
infoLua = {}              --
Woe = {}                  --
Woe.__index = Woe         --
----------------------------

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

function Woe.guildName()
	Woe.getInfo()
	return infoLua[2] ~= 0 and Woe.getGuildName(infoLua[2]) or 'Nones'
end

function Woe.isTime()
	return Game.getStorageValue(stor_WoeTime) == 1
end

function Player:isRegistered()
	return player:getStorageValue(stor_register) >= 1
end
