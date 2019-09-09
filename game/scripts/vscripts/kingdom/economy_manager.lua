-- Economy manager initialization
if EconomyManager == nil then
	_G.EconomyManager = class({})
end

-- Initialization
function EconomyManager:Init()
	print("--- Economy manager: initializing")

	-- Set up economy constants
	self.turn_count = 0
	self.initial_delay = 10
	self.turn_duration = 45

	self.starting_gold = 0
	self.base_income = 5
	self.city_income = {2, 3, 5}
	self.lost_city_income = 10
	self.region_income = 10
	self.base_interest = 0.2

	self.player_current_city_amount = {}
	for player = 1, Kingdom:GetPlayerCount() do
		self.player_current_city_amount[player] = MapManager:GetPlayerCityCount(player)
	end

	print("- Economy manager: starting game turns")
	Timers:CreateTimer(self.initial_delay, function()
		self:GrantPlayerTurnIncome()
		return self.turn_duration
	end)

	print("Economy manager: finished initializing")
end



-- Income management
function EconomyManager:GrantPlayerTurnIncome()
	self.turn_count = self.turn_count + 1

	print("- Economy manager: TURN "..self.turn_count.." INCOME")
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		local current_gold = PlayerResource:GetGold(player_id)

		-- Income calculation
		local turn_income = self.base_income
		local interest = math.floor(current_gold) * self.base_interest
		local region_income = MapManager:GetPlayerRegionCount(player) * self.region_income
		local lost_city_income = math.max(self.player_current_city_amount[player] - MapManager:GetPlayerCityCount(player), 0) * self.lost_city_income
		self.player_current_city_amount[player] = MapManager:GetPlayerCityCount(player)

		local city_income = 0
		for region = 1, MapManager:GetRegionCount() do
			for city = 1, MapManager:GetRegionCityCount(region) do
				if MapManager:GetCityOwner(region, city) == player then
					city_income = city_income + self.city_income[MapManager:GetCityByNumber(region, city):GetLevel()]
				end
			end
		end

		local total_income = turn_income + interest + region_income + lost_city_income + city_income
		PlayerResource:ModifyGold(player_id, total_income, true, DOTA_ModifyGold_HeroKill)
		print("Player "..player.." received "..total_income.." total income, "..turn_income.." base, "..interest.." from interest, "..region_income.." from owned regions, "..city_income.." from owned cities, "..lost_city_income.." from cities lost since the last turn.")
	end
end



-- Unit spawners
function EconomyManager:SpawnUnit(region, city, unit_type)
	local player = MapManager:GetCityOwner(region, city)
	local player_id = Kingdom:GetPlayerID(player)
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local city_race = MapManager:GetCityRace(region, city)
	local spawn_loc = MapManager:GetCityMeleeSpawnPoint(region, city)
	if unit_type == "ranged" then
		spawn_loc = MapManager:GetCityRangedSpawnPoint(region, city)
	end
	local unit = CreateUnitByName("npc_kingdom_"..city_race.."_"..unit_type, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
	unit:SetControllableByPlayer(player_id, true)
	--unit:SetRenderColor(player_color.x, player_color.y, player_color.z)
	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(unit:GetAbsOrigin(), 128)
	end)
end