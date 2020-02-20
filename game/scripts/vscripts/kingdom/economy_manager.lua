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
	self.lost_city_income = 10
	self.region_income = 10
	self.base_interest = 0.1
	self.max_interest = 10
	self.beast_spawns = 3
	self.max_beast_spawns = 12
	self.current_beasts = {}

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
		self.max_turns = 2
	end

	-- Player starting gold
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		PlayerResource:ModifyGold(player_id, math.floor(self.starting_gold), true, DOTA_ModifyGold_HeroKill)
	end

	-- Initialize scoreboard nettable
	CustomNetTables:SetTableValue("player_info", "turn_timer", {turn_timer = self.turn_duration})
	CustomNetTables:SetTableValue("player_info", "turn_state", {turn_state = "normal"})
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		CustomNetTables:SetTableValue("player_info", "player_"..player_id, {income = self.base_income})
		CustomNetTables:SetTableValue("player_info", "player_steam_id_"..player_id, {player_steam_id = PlayerResource:GetSteamID(player_id)})
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
				CustomNetTables:SetTableValue("player_info", "turn_timer", {turn_timer = self.turn_timer})
				return 1
			end)
		end
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

	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		local current_gold = PlayerResource:GetGold(player_id)

		-- Income calculation
		local turn_income = self.base_income
		local interest = math.min(math.floor(current_gold * self.base_interest), self.max_interest)
		local region_income = MapManager:GetPlayerRegionCount(player) * self.region_income
		local lost_city_income = math.max(self.player_current_city_amount[player] - MapManager:GetPlayerCityCount(player), 0) * self.lost_city_income
		local unit_income = (-1) * math.floor(self.player_current_units[player] / 3)
		local bonus_income = 0
		self.player_current_city_amount[player] = MapManager:GetPlayerCityCount(player)

		local city_income = 0
		for region = 1, MapManager:GetRegionCount() do
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
	end
end

function EconomyManager:UpdateIncomeForPlayer(player)
	local player_id = Kingdom:GetPlayerID(player)
	local current_gold = PlayerResource:GetGold(player_id)

	-- Income calculation
	local turn_income = self.base_income
	local interest = math.min(math.floor(current_gold * self.base_interest), self.max_interest)
	local region_income = MapManager:GetPlayerRegionCount(player) * self.region_income
	local lost_city_income = math.max(self.player_current_city_amount[player] - MapManager:GetPlayerCityCount(player), 0) * self.lost_city_income
	local unit_income = (-1) * math.floor(self.player_current_units[player] / 3)
	local bonus_income = 0

	local city_income = 0
	for region = 1, MapManager:GetRegionCount() do
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

function EconomyManager:SpawnBeasts(region, player)
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local spawn_loc = MapManager:GetBeastSpawnPoint(region)
	local beasts_to_spawn = math.min(self.beast_spawns, self.max_beast_spawns - self.current_beasts[region])

	if beasts_to_spawn >= 1 then
		for i = 1, beasts_to_spawn do
			local unit = CreateUnitByName("npc_kingdom_beast_"..region, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
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
	local city_hero = MapManager:GetCityHero(region, city)
	local spawn_loc = MapManager:GetCityMeleeSpawnPoint(region, city)
	local unit = CreateUnitByName("npc_kingdom_hero_"..city_hero, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	unit:SetControllableByPlayer(player_id, true)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_hero_marker", {ability_name = "kingdom_buy_hero_"..city_hero, region = region, city = city})
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
	event.unitname = "npc_kingdom_hero_"..city_hero
	event.heroname = Kingdom:GetDotaNameFromHeroName(event.unitname)

	CustomGameEventManager:Send_ServerToAllClients("kingdom_hero_recruited", {event})

	return unit
end

function EconomyManager:SpawnDemonHero(portal, hero_name)
	local player = MapManager.demon_portals[portal]["owner_player"]
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local spawn_loc = MapManager.demon_portals[portal]["capture_point"]

	local unit = CreateUnitByName("npc_kingdom_hero_"..hero_name, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	unit:SetControllableByPlayer(player_id, true)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_demon_hero_marker", {ability_name = "kingdom_buy_hero_"..hero_name})
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
	event.unitname = "npc_kingdom_hero_"..hero_name
	event.heroname = Kingdom:GetDotaNameFromHeroName(event.unitname)

	CustomGameEventManager:Send_ServerToAllClients("kingdom_hero_recruited", {event})

	return unit
end