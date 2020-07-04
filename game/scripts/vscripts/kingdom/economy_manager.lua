-- Economy manager initialization
if EconomyManager == nil then
	_G.EconomyManager = class({})
end

-- Initialization
function EconomyManager:Init()
	print("--- Economy manager: initializing")

	-- Set up economy constants
	self.turn_count = 0
	self.turn_timer = 25
	self.turn_duration = 45
	self.last_turn_duration = 60
	self.max_turns = 40
	self.overtime_active = false

	self.starting_gold = 25
	self.base_income = 0
	self.capital_income = 5
	self.city_income = {1, 3, 5}
	self.talneas_income_bonus = {10, 20}
	self.item_income_bonus = 25
	self.lost_city_income = 10
	self.base_interest = 0.1
	self.max_interest = 10
	self.beast_spawns = 3
	self.max_beast_spawns = 12

	self.region_income = {}

	if GetMapName() == "disputed_lands" then
		self.region_income[1] = 10
		self.region_income[2] = 10
		self.region_income[3] = 10
		self.region_income[4] = 10
		self.region_income[5] = 10
		self.region_income[6] = 10
		self.region_income[7] = 10
		self.region_income[8] = 10
	elseif GetMapName() == "twin_kingdoms" then
		self.region_income[1] = 10
		self.region_income[2] = 10
		self.region_income[3] = 15
		self.region_income[4] = 15
		self.region_income[5] = 10
		self.region_income[6] = 15
		self.region_income[7] = 15
		self.region_income[8] = 15
		self.region_income[9] = 10
		self.region_income[10] = 10
		self.region_income[11] = 10
		self.region_income[12] = 15
		self.region_income[13] = 15
		self.region_income[14] = 10
		self.region_income[15] = 15
		self.region_income[16] = 10
	end

	self.item_drop_turns = {}
	self.item_drop_turns[5] = table.remove(MapManager.match_items)
	self.item_drop_turns[11] = table.remove(MapManager.match_items)
	self.item_drop_turns[17] = table.remove(MapManager.match_items)
	self.item_drop_turns[23] = table.remove(MapManager.match_items)
	self.item_drop_turns[29] = table.remove(MapManager.match_items)

	self.item_circle_colors = {}
	table.insert(self.item_circle_colors, Vector(255, 100, 100)	)
	table.insert(self.item_circle_colors, Vector(255, 0, 100)	)
	table.insert(self.item_circle_colors, Vector(255, 100, 0)	)
	table.insert(self.item_circle_colors, Vector(100, 255, 100)	)
	table.insert(self.item_circle_colors, Vector(0, 255, 100)	)
	table.insert(self.item_circle_colors, Vector(100, 255, 0)	)
	table.insert(self.item_circle_colors, Vector(100, 100, 255)	)
	table.insert(self.item_circle_colors, Vector(0, 100, 255)	)
	table.insert(self.item_circle_colors, Vector(100, 0, 255)	)
	table.insert(self.item_circle_colors, Vector(255, 255, 100)	)
	table.insert(self.item_circle_colors, Vector(255, 100, 255)	)
	table.insert(self.item_circle_colors, Vector(100, 255, 255)	)

	self.current_beasts = {}
	self.spawned_heroes = {}

	self.map_beasts = {}
	self.map_beasts["disputed_lands"] = "npc_kingdom_beast_5"
	self.map_beasts["twin_kingdoms"] = "npc_kingdom_beast_2"

	for region = 1, MapManager:GetRegionCount() do
		self.current_beasts[region] = 0
	end

	self.player_current_city_amount = {}
	self.player_current_units = {}
	for player = 1, Kingdom:GetPlayerCount() do
		self.player_current_city_amount[player] = MapManager:GetPlayerCityCount(player)
		self.player_current_units[player] = 0
	end

	if IsInToolsMode() then
		self.turn_timer = 12
		self.starting_gold = 100
		self.max_turns = 20
	end

	-- Player starting gold
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		PlayerResource:ModifyGold(player_id, math.floor(self.starting_gold), true, DOTA_ModifyGold_HeroKill)
	end

	-- Initialize scoreboard nettable
	CustomNetTables:SetTableValue("player_info", "turn_timer", {turn_timer = self.turn_duration})
	CustomNetTables:SetTableValue("player_info", "turn_state", {turn_state = "normal"})
	CustomNetTables:SetTableValue("player_info", "turn_count", {turn_count = self.turn_count + 1})
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		CustomNetTables:SetTableValue("player_info", "player_"..player_id, {income = self.base_income})
		CustomNetTables:SetTableValue("player_info", "player_steam_id_"..player_id, {player_steam_id = PlayerResource:GetSteamID(player_id)})
		CustomNetTables:SetTableValue("player_info", "player_name_"..player_id, {player_name = PlayerResource:GetPlayerName(player_id)})
		self:UpdateIncomeForPlayer(player)
	end

	-- Initialize capital choice warning
	local event = {}
	event.time = self.turn_timer
	CustomGameEventManager:Send_ServerToAllClients("kingdom_capital_choice_phase", {event})

	print("Economy manager: finished initializing")
end

-- Game start
function EconomyManager:StartCapitalPhase()
	print("- Economy manager: capital choice time")
	Timers:CreateTimer(1, function()
		self.turn_timer = self.turn_timer - 1

		local event = {}
		event.time = self.turn_timer
		CustomGameEventManager:Send_ServerToAllClients("kingdom_capital_choice_phase", {event})

		if self.turn_timer > 0 then
			return 1
		else
			MapManager:StartMatch()
			self:GrantPlayerTurnIncome()
			self.turn_timer = self.turn_duration

			print("- Economy manager: starting game turns")
			Timers:CreateTimer(1, function()
				self.turn_timer = self.turn_timer - 1
				if self.turn_timer <= 0 then
					self.turn_count = self.turn_count + 1

					if self.item_drop_turns[self.turn_count] then
						self:SpawnDemonPortalItem(table.remove(MapManager.match_portals), self.item_drop_turns[self.turn_count])
					end

					if self.turn_count > self.max_turns then
						self:EndGameByRoundLimit()
						return nil
					else
						self:GrantPlayerTurnIncome()
					end

					if self.turn_count == self.max_turns then
						self.turn_timer = self.last_turn_duration
						CustomNetTables:SetTableValue("player_info", "turn_state", {turn_state = "last_turn"})
					else
						self.turn_timer = self.turn_duration
					end
				end
				CustomNetTables:SetTableValue("player_info", "turn_count", {turn_count = self.turn_count + 1})
				CustomNetTables:SetTableValue("player_info", "turn_timer", {turn_timer = self.turn_timer})
				return 1
			end)
		end
	end)
end

-- Spawns an item in a demon portal
function EconomyManager:SpawnDemonPortalItem(portal_data, item_name)
	local item_loc = Vector(portal_data["capture_zone"]["x"], portal_data["capture_zone"]["y"], portal_data["capture_zone"]["height"] + 10)

	local item_summoning_pfx = ParticleManager:CreateParticle("particles/item_summoning_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(item_summoning_pfx, 0, item_loc)
	ParticleManager:SetParticleControl(item_summoning_pfx, 1, table.remove(self.item_circle_colors))

	EmitGlobalSound("Item.Warning")

	CustomGameEventManager:Send_ServerToAllClients("kingdom_announce_item_warning", {region = portal_data.region})
	CustomGameEventManager:Send_ServerToAllClients("kingdom_minimap_ping", {x = item_loc.x, y = item_loc.y, z = item_loc.z + 10})

	Timers:CreateTimer(self.turn_duration, function()
		ParticleManager:DestroyParticle(item_summoning_pfx, false)
		ParticleManager:ReleaseParticleIndex(item_summoning_pfx)

		EmitGlobalSound("Item.Arrive")

		CreateItemOnPositionSync(item_loc, CreateItem(item_name, nil, nil))

		CustomGameEventManager:Send_ServerToAllClients("kingdom_announce_item_drop", {region = portal_data.region})
		CustomGameEventManager:Send_ServerToAllClients("kingdom_minimap_ping", {x = item_loc.x, y = item_loc.y, z = item_loc.z + 10})
	end)
end

-- Game end via time limit
function EconomyManager:EndGameByRoundLimit()
	local most_cities = 0
	local winner = 0
	local tie = false

	for player = 1, Kingdom:GetPlayerCount() do
		if MapManager.player_city_count[player] > most_cities then
			most_cities = MapManager.player_city_count[player]
			winner = player
			tie = false
		elseif MapManager.player_city_count[player] == most_cities then
			tie = true
		end
	end

	if tie then
		self.overtime_active = true
		CustomNetTables:SetTableValue("player_info", "turn_state", {turn_state = "overtime"})
	else
		Kingdom:SetWinner(winner)
	end
end

function EconomyManager:IsOvertime()
	return self.overtime_active
end

-- Income management
function EconomyManager:GrantPlayerTurnIncome()
	print("- Economy manager: TURN "..self.turn_count.." INCOME")

	if self.turn_count > 0 then
		EmitGlobalSound("Round.Income")
		CustomGameEventManager:Send_ServerToAllClients("kingdom_turn_ended", {})
	end

	if self.turn_count == 10 or self.turn_count == 20 or self.turn_count == 30 then
		Timers:CreateTimer(10, function()
			CustomGameEventManager:Send_ServerToAllClients("kingdom_announce_discord", {})
		end)
	end

	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		local current_gold = PlayerResource:GetGold(player_id)

		-- Income calculation
		local turn_income = self.base_income
		local interest = math.min(math.floor(current_gold * self.base_interest), self.max_interest)
		local lost_city_income = math.max(self.player_current_city_amount[player] - MapManager:GetPlayerCityCount(player), 0) * self.lost_city_income
		local unit_income = (-1) * math.floor(self.player_current_units[player] / 3)
		local bonus_income = 0
		self.player_current_city_amount[player] = MapManager:GetPlayerCityCount(player)

		local region_income = 0
		local city_income = 0
		for region = 1, MapManager:GetRegionCount() do
			if MapManager:IsRegionOwner(region, player) then
				region_income = region_income + self.region_income[region]
			end

			for city = 1, MapManager:GetRegionCityCount(region) do
				if MapManager:GetCityOwner(region, city) == player then
					city_income = city_income + self.city_income[MapManager:GetCityByNumber(region, city):GetLevel()]

					-- Capital bonus
					if MapManager:GetCityByNumber(region, city):HasModifier("modifier_kingdom_capital") then
						city_income = city_income + self.capital_income
					end

					-- Regional bonuses
					if MapManager:GetCityByNumber(region, city):HasModifier("modifier_kingdom_r4_owner_full") then
						bonus_income = self.talneas_income_bonus[2]
					elseif MapManager:GetCityByNumber(region, city):HasModifier("modifier_kingdom_r4_owner_half") then
						bonus_income = self.talneas_income_bonus[1]
					end
				end
			end

			-- Spawn beasts
			if MapManager:IsRegionOwner(region, player) then
				self:SpawnBeasts(region, player)
			end
		end

		local total_income = math.max(0, turn_income + interest + region_income + lost_city_income + city_income + unit_income + bonus_income)
		PlayerResource:ModifyGold(player_id, math.floor(total_income), true, DOTA_ModifyGold_HeroKill)
		print("Player "..player.." received "..total_income.." total income, "..turn_income.." base, "..interest.." from interest, "..bonus_income.." from regional bonuses, "..region_income.." from owned regions, "..city_income.." from owned cities, "..unit_income.." from unit upkeep, "..lost_city_income.." from cities lost since the last turn.")
		self:UpdateIncomeForPlayer(player)

		if Kingdom:IsBot(player) then
			EconomyManager:PlanBotTurn(player)
		end
	end
end

function EconomyManager:UpdateIncomeForPlayer(player)
	local player_id = Kingdom:GetPlayerID(player)
	local current_gold = PlayerResource:GetGold(player_id)

	-- Income calculation
	local turn_income = self.base_income
	local interest = math.min(math.floor(current_gold * self.base_interest), self.max_interest)
	local lost_city_income = math.max(self.player_current_city_amount[player] - MapManager:GetPlayerCityCount(player), 0) * self.lost_city_income
	local unit_income = (-1) * math.floor(self.player_current_units[player] / 3)
	local bonus_income = 0

	local region_income = 0
	local city_income = 0
	for region = 1, MapManager:GetRegionCount() do
		if MapManager:IsRegionOwner(region, player) then
			region_income = region_income + self.region_income[region]
		end

		for city = 1, MapManager:GetRegionCityCount(region) do
			if MapManager:GetCityOwner(region, city) == player then
				city_income = city_income + self.city_income[MapManager:GetCityByNumber(region, city):GetLevel()]

				-- Capital bonus
				if MapManager:GetCityByNumber(region, city):HasModifier("modifier_kingdom_capital") then
					city_income = city_income + self.capital_income
				end

				if MapManager:GetCityByNumber(region, city):HasModifier("modifier_kingdom_r4_owner_full") then
					bonus_income = self.talneas_income_bonus[2]
				elseif MapManager:GetCityByNumber(region, city):HasModifier("modifier_kingdom_r4_owner_half") then
					bonus_income = self.talneas_income_bonus[1]
				end
			end
		end
	end

	local total_income = math.max(0, turn_income + interest + region_income + lost_city_income + city_income + unit_income + bonus_income)
	CustomNetTables:SetTableValue("player_info", "player_"..player_id, {income = total_income})
end

function EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, gold_spent)
	--local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	--local current_income = CustomNetTables:GetTableValue("player_info", "player_"..player_id).income
	--local new_income = current_income - gold_spent * self.base_interest
	--CustomNetTables:SetTableValue("player_info", "player_"..player_id, {income = new_income})
end

function EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(caster, gold_spent)
	--local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
	--local current_income = CustomNetTables:GetTableValue("player_info", "player_"..player_id).income
	--local new_income = current_income - gold_spent * self.base_interest
	--CustomNetTables:SetTableValue("player_info", "player_"..player_id, {income = new_income})
end

function EconomyManager:Rally(unit, city)
	if city.rally_point then
		Timers:CreateTimer(0.1, function()
			unit:MoveToPositionAggressive(city.rally_point)
		end)
	end
end



-- Unit spawners
function EconomyManager:SpawnUnit(region, city, unit_type)
	local player = MapManager:GetCityOwner(region, city)
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local city_race = MapManager:GetCityRace(region, city)
	local spawn_loc = MapManager:GetCityMeleeSpawnPoint(region, city)
	if unit_type == "ranged" then
		spawn_loc = MapManager:GetCityRangedSpawnPoint(region, city)
	end

	local unit = CreateUnitByName("npc_kingdom_"..city_race.."_"..unit_type, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	unit:SetControllableByPlayer(player_id, true)

	Voices:PlayLine(VOICE_EVENT_SPAWN_UNIT, unit)

	-- Movement limit removal modifier
	unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {player = player})

	if unit_type == "melee" then
		unit.type = KINGDOM_UNIT_TYPE_MELEE
	elseif unit_type == "ranged" then
		unit.type = KINGDOM_UNIT_TYPE_RANGED
	elseif unit_type == "cavalry" then
		unit.type = KINGDOM_UNIT_TYPE_CAVALRY
	end

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(unit:GetAbsOrigin(), 128)

		local rally_point = MapManager:GetRallyPoint(region, city)
		if rally_point then
			unit:MoveToPositionAggressive(rally_point)
		end
	end)

	-- City level bonuses
	local city_unit = MapManager:GetCityByNumber(region, city)

	if city_unit:GetLevel() >= 3 then
		unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
	elseif city_unit:GetLevel() == 2 then
		unit:AddAbility("kingdom_elite_unit"):SetLevel(1)
	end

	-- Regional bonuses
	if GetMapName() == "disputed_lands" then
		if MapManager:IsRegionOwner(1, player) and unit_type == "melee" then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_attack_bonus_melee", {})
		elseif MapManager:IsRegionOwner(2, player) and unit_type == "cavalry" then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_attack_bonus_cavalry", {})
		elseif MapManager:IsRegionOwner(6, player) and unit_type == "ranged" then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_attack_bonus_ranged", {})
		end

		if MapManager:IsRegionOwner(3, player) then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_health_bonus_full", {})
		elseif MapManager:IsRegionContender(3, player) then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_health_bonus", {})
		end

		if MapManager:IsRegionOwner(7, player) then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_as_bonus_full", {})
		elseif MapManager:IsRegionContender(7, player) then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_as_bonus", {})
		end

		if MapManager:IsRegionOwner(8, player) then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_armor_bonus_full", {})
		elseif MapManager:IsRegionContender(8, player) then
			unit:AddNewModifier(unit, nil, "modifier_kingdom_region_armor_bonus", {})
		end
	end
end

function EconomyManager:SpawnBeasts(region, player)
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local spawn_loc = MapManager:GetBeastSpawnPoint(region)
	local beasts_to_spawn = math.min(self.beast_spawns, self.max_beast_spawns - self.current_beasts[region])
	local beast_name = self.map_beasts[GetMapName()]

	if beasts_to_spawn >= 1 then
		for i = 1, beasts_to_spawn do
			local unit = CreateUnitByName(beast_name, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
			unit:AddNewModifier(unit, nil, "modifier_kingdom_beast_marker", {region = region})
			unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {})
			unit:SetControllableByPlayer(player_id, true)
			unit.type = KINGDOM_UNIT_TYPE_BEAST
		end
	end

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(spawn_loc, 128)
	end)
end

function EconomyManager:SpawnDemon(portal, unit_type)
	local player = MapManager.demon_portals[portal]["owner_player"]
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local spawn_loc = MapManager.demon_portals[portal]["capture_point"]
	if unit_type == "ranged" then
		spawn_loc = spawn_loc + Vector(-192, 192, 0)
	end

	local unit = CreateUnitByName("npc_kingdom_demon_"..unit_type, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	unit:SetControllableByPlayer(player_id, true)

	Voices:PlayLine(VOICE_EVENT_SPAWN_UNIT, unit)

	-- Movement limit removal modifier
	unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {player = player})

	if unit_type == "melee" then
		unit.type = KINGDOM_UNIT_TYPE_MELEE
	elseif unit_type == "ranged" then
		unit.type = KINGDOM_UNIT_TYPE_RANGED
	elseif unit_type == "cavalry" then
		unit.type = KINGDOM_UNIT_TYPE_CAVALRY
	end

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(unit:GetAbsOrigin(), 128)

		local rally_point = MapManager:GetPortalRallyPoint(portal)
		if rally_point then
			unit:MoveToPositionAggressive(rally_point)
		end
	end)

	-- Racial bonuses
	unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
end

function EconomyManager:SpawnHero(region, city)
	local player = MapManager:GetCityOwner(region, city)
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local hero_name = "npc_kingdom_hero_"..MapManager:GetCityHero(region, city)
	local spawn_loc = MapManager:GetCityMeleeSpawnPoint(region, city)

	if not EconomyManager.spawned_heroes[hero_name] then
		EconomyManager.spawned_heroes[hero_name] = CreateUnitByName(hero_name, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	end

	local unit = EconomyManager.spawned_heroes[hero_name]

	if not unit:IsAlive() then
		unit:SetRespawnPosition(spawn_loc)
		unit:RespawnHero(false, false)
	end

	unit:SetControllableByPlayer(player_id, true)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_hero_marker", {ability_name = "kingdom_buy_hero_"..MapManager:GetCityHero(region, city), region = region, city = city})
	unit:SetHullRadius(48)

	-- Movement limit removal modifier
	unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {player = player})

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(unit:GetAbsOrigin(), 128)

		local rally_point = MapManager:GetRallyPoint(region, city)
		if rally_point then
			unit:MoveToPositionAggressive(rally_point)
		end
	end)

	local event = {}
	event.playerid = player_id
	event.playername = PlayerResource:GetPlayerName(player_id)
	event.steamid = PlayerResource:GetSteamID(player_id)
	event.unitname = hero_name
	event.heroname = Kingdom:GetDotaNameFromHeroName(event.unitname)

	CustomGameEventManager:Send_ServerToAllClients("kingdom_hero_recruited", {event})

	return unit
end

function EconomyManager:SpawnDemonHero(portal, hero_name)
	local player = MapManager.demon_portals[portal]["owner_player"]
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local spawn_loc = MapManager.demon_portals[portal]["capture_point"]
	hero_name = "npc_kingdom_hero_"..hero_name

	if not EconomyManager.spawned_heroes[hero_name] then
		EconomyManager.spawned_heroes[hero_name] = CreateUnitByName(hero_name, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	end

	local unit = EconomyManager.spawned_heroes[hero_name]

	if not unit:IsAlive() then
		unit:SetRespawnPosition(spawn_loc)
		unit:RespawnHero(false, false)
	end

	unit:SetControllableByPlayer(player_id, true)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_demon_hero_marker", {ability_name = hero_name})
	unit:SetHullRadius(48)

	-- Movement limit removal modifier
	unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {player = player})

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(unit:GetAbsOrigin(), 128)

		local rally_point = MapManager:GetPortalRallyPoint(portal)
		if rally_point then
			unit:MoveToPositionAggressive(rally_point)
		end
	end)

	local event = {}
	event.playerid = player_id
	event.playername = PlayerResource:GetPlayerName(player_id)
	event.steamid = PlayerResource:GetSteamID(player_id)
	event.unitname = hero_name
	event.heroname = Kingdom:GetDotaNameFromHeroName(event.unitname)

	CustomGameEventManager:Send_ServerToAllClients("kingdom_hero_recruited", {event})

	return unit
end

function EconomyManager:PlanBotTurn(player)
	if MapManager.player_eliminated[player] then
		return nil
	end

	local bot_aggro = Kingdom:GetBotAggro(player)
	local player_id = Kingdom:GetPlayerID(player)
	local bot_gold = PlayerResource:GetGold(player_id)

	-- Random parameters for this turn
	local spawn_delay = self.turn_duration * 0.5 * (bot_aggro + RandomInt(0, 25)) * 0.01
	local turn_targets = math.ceil((bot_aggro + RandomInt(0, 25)) * 0.01 * bot_gold * 0.02)
	local attack_delay = self.turn_duration * 0.5 / (1 + turn_targets)
	local city_budget = math.floor(bot_gold / turn_targets)

	local owned_cities = {}
	for region = 1, MapManager:GetRegionCount() do
		for city = 1, MapManager:GetRegionCityCount(region) do
			if MapManager:GetCityOwner(region, city) == player then
				table.insert(owned_cities, MapManager:GetCityByNumber(region, city))
			end
		end
	end

	local city_units = {}
	city_units[1] = "_melee"
	city_units[2] = "_ranged"
	city_units[3] = "_cavalry"

	for i = 1, turn_targets do
		Timers:CreateTimer(spawn_delay, function()
			local spawn_city = owned_cities[RandomInt(1, #owned_cities)]
			local current_budget = city_budget
			local city_race = MapManager:GetCityRace(spawn_city:GetRegion(), spawn_city:GetCity())
			local next_unit = city_units[RandomInt(1, 3)]
			local next_unit_cost = spawn_city:FindAbilityByName("kingdom_buy_"..city_race..next_unit):GetGoldCost(1)

			while next_unit_cost <= current_budget do
				spawn_city:FindAbilityByName("kingdom_buy_"..city_race..next_unit):OnSpellStart()
				current_budget = current_budget - next_unit_cost
				PlayerResource:SpendGold(player_id, next_unit_cost, DOTA_ModifyGold_PurchaseItem)

				next_unit = city_units[RandomInt(1, 3)]
				next_unit_cost = spawn_city:FindAbilityByName("kingdom_buy_"..city_race..next_unit):GetGoldCost(1)
			end

			Timers:CreateTimer(i * attack_delay, function()
				local city_location = MapManager:GetCityCaptureZoneCenter(spawn_city:GetRegion(), spawn_city:GetCity())
				local target_loc = city_location
				local targets = FindUnitsInRadius(spawn_city:GetTeamNumber(), city_location, nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
				for _, enemy in pairs(targets) do
					if enemy:HasModifier("modifier_kingdom_city") and enemy:GetUnitName() ~= "npc_kingdom_city_demon" then
						target_loc = MapManager:GetCityCaptureZoneCenter(enemy:GetRegion(), enemy:GetCity())
						break
					end
				end

				local allies = FindUnitsInRadius(spawn_city:GetTeamNumber(), city_location, nil, 400, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, ally in pairs(allies) do
					if ally:HasModifier("modifier_kingdom_unit_movement") then
						ExecuteOrderFromTable({
							UnitIndex = ally:entindex(),
							OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
							Position = target_loc
						})
					end
				end
			end)
		end)
	end
end