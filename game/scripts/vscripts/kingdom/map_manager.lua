-- Map manager initialization
if MapManager == nil then
	_G.MapManager = class({})
end

-- Map initialization
function MapManager:Init()
	print("--- Map manager: initializing")

	-- Load map information
	self.map_info = LoadKeyValues("scripts/npc/KV/map.kv")
	self.neutrals_map_info = LoadKeyValues("scripts/npc/KV/map_neutrals.kv")

	-- Set up geography constants
	self.city_capture_time = {2, 5, 10}
	self.capital_capture_time = 10
	self.region_count = 0
	self.city_count = 0
	self.demon_portal_count = 3
	self.region_city_count = {}

	local region_number = 1
	for region_key, region in pairs(self.map_info) do
		self.region_count = self.region_count + 1
		self.region_city_count[region_number] = 0
		region_number = region_number + 1
	end

	for region = 1, self.region_count do
		for _, city in pairs(self.map_info[tostring(region)]) do
			self.city_count = self.city_count + 1
			self.region_city_count[region] = self.region_city_count[region] + 1
		end
	end

	-- Generate city information
	self.city_owners = {}
	self.cities = {}
	self.towers = {}
	self.tower_bases = {}
	self.capture_info = {}
	self.demon_portals = {}
	self.rally_points = {}
	self.regional_spawners = {}
	for region = 1, self:GetRegionCount() do
		self.city_owners[region] = {}
		self.cities[region] = {}
		self.towers[region] = {}
		self.tower_bases[region] = {}
		self.rally_points[region] = {}
		self.regional_spawners[region] = {}
		self.capture_info[region] = {}
		for city = 1, self:GetRegionCityCount(region) do
			self.city_owners[region][city] = 0
			self.capture_info[region][city] = {}
		end
	end

	-- Distribute cities amongst players randomly
	print("- Map manager: distributing cities amongst players")
	self:PerformInitialCityDistribution()

	-- Spawn demon portals
	print("- Map manager: spawning demon portals")
	self:SpawnDemonPortals()

	-- Spawn regional controllers/ beast spawners
	print("- Map manager: spawning regional spawners")
	self:SpawnRegionalSpawners()

	-- Spawn towers and cities for each player
	print("- Map manager: spawning cities and towers")
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:SpawnTower(region, city)
			self:SpawnCity(region, city)
		end
	end

	-- Initialize player city and region count
	self.player_sovereign_regions = {}
	self.player_contender_regions = {}
	self.player_region_count = {}
	self.player_city_count = {}
	self.player_city_count_by_region = {}
	self.player_eliminated = {}
	self.is_near_win = {}
	self.is_very_near_win = {}
	self.players_remaining = Kingdom:GetPlayerCount()

	for player_number = 1, Kingdom:GetPlayerCount() do
		self.player_region_count[player_number] = 0
		self.player_city_count[player_number] = 0
		self.player_city_count_by_region[player_number] = {}
		self.player_sovereign_regions[player_number] = {}
		self.player_contender_regions[player_number] = {}
		self.player_eliminated[player_number] = false
		self.is_near_win[player_number] = false
		self.is_very_near_win[player_number] = false
		for region = 1, self:GetRegionCount() do
			self.player_city_count_by_region[player_number][region] = 0
			self.player_sovereign_regions[player_number][region] = false
			self.player_contender_regions[player_number][region] = false
		end
	end

	-- Initialize region info nettable
	local region_info = {}
	region_info.owners = {}
	region_info.contenders = {}

	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		region_info.owners[player_id] = {}
		region_info.contenders[player_id] = {}
		for region = 1, self:GetRegionCount() do
			region_info.owners[player_id][region] = false
			region_info.contenders[player_id][region] = false
		end
	end

	CustomNetTables:SetTableValue("region_info", "region_owners", region_info)

	--self:UpdatePlayerCityCounts()

	-- Start tracking captures
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:StartCaptureTracking(region, city)
		end
	end

	-- Same, but for demon portals
	for portal = 1, self:GetDemonPortalCount() do
		self:StartPortalCaptureTracking(portal)
	end

	print("Map manager: finished initializing")
end

-- Map startup (at match start)
function MapManager:StartCapitalPhase()
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:SetCityControllable(region, city, self:GetCityOwner(region, city))
		end
	end
end

function MapManager:StartMatch()
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		print("player id: "..player_id)
		local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)

		if player_hero:FindAbilityByName("kingdom_upgrade_to_capital") then

			local keep_looking = true
			while keep_looking do
				local region = RandomInt(1, self:GetRegionCount())
				local city = RandomInt(1, self:GetRegionCityCount(region))

				if self:GetCityOwner(region, city) == player then
					self:ForceCapital(player_hero, self:GetCityByNumber(region, city), region, city, player)
					keep_looking = false
				end
			end
		end
	end

	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:GetCityByNumber(region, city):RemoveModifierByName("modifier_kingdom_city_pregame")			
		end
	end

	self:UpdatePlayerCityCounts()
end

function MapManager:ForceCapital(player_hero, city_unit, region, city, player)
	local player_id = Kingdom:GetPlayerID(player)
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	local target_loc = city_unit:GetAbsOrigin()

	EmitSoundOnClient("General.FemaleLevelUp", PlayerResource:GetPlayer(player_id))

	local flash_pfx = ParticleManager:CreateParticle("particles/city_upgrade_capital.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(flash_pfx, 0, target_loc)
	ParticleManager:ReleaseParticleIndex(flash_pfx)

	city_unit:Destroy()
	MapManager:SpawnCapital(region, city)
	city_unit = MapManager:GetCityByNumber(region, city)
	MapManager:SetCityControllable(region, city, player)

	city_unit.capital_pfx = ParticleManager:CreateParticle("particles/capital_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(city_unit.capital_pfx, 0, target_loc + Vector(0, 0, 10))
	ParticleManager:SetParticleControl(city_unit.capital_pfx, 1, player_color)

	player_hero:AddNewModifier(player_hero, nil, "modifier_kingdom_hero_after_capital_selection", {})
	player_hero:RemoveAbility("kingdom_upgrade_to_capital")
	city_unit:AddAbility("kingdom_capital"):SetLevel(1)

	MapManager:UpgradeCapitalTower(region, city)

	EconomyManager:UpdateIncomeForPlayer(player)

	local event = {}
	event.playerid = player_id
	event.playername = PlayerResource:GetPlayerName(player_id)
	event.steamid = PlayerResource:GetSteamID(player_id)
	event.cityname = "#npc_kingdom_city_"..region.."_"..city

	CustomGameEventManager:Send_ServerToAllClients("kingdom_capital_chosen", {event})
	CustomGameEventManager:Send_ServerToAllClients("kingdom_minimap_ping", {x = target_loc.x, y = target_loc.y, z = target_loc.z + 10})
end

-- Geographical information
function MapManager:GetRegionCount()
	return self.region_count
end

function MapManager:GetCityCount()
	return self.city_count
end

function MapManager:GetDemonPortalCount()
	return self.demon_portal_count
end

function MapManager:GetRegionCityCount(region)
	return self.region_city_count[region]
end

function MapManager:IsCapital(region, city)
	return self.cities[region][city]:HasModifier("modifier_kingdom_capital")
end

function MapManager:GetCityRace(region, city)
	return self.map_info[tostring(region)][tostring(city)]["race"]
end

function MapManager:GetCityHero(region, city)
	return self.map_info[tostring(region)][tostring(city)]["hero"]
end

function MapManager:GetCityOrigin(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["city"]["x"], self.map_info[tostring(region)][tostring(city)]["city"]["y"], 0)
end

function MapManager:GetCityFacing(region, city)
	return self.map_info[tostring(region)][tostring(city)]["city"]["angle"]
end

function MapManager:GetCityTowerSpawnPoint(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["tower"]["x"], self.map_info[tostring(region)][tostring(city)]["tower"]["y"], 0)
end

function MapManager:GetCityMeleeSpawnPoint(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["capture_zone"]["x"], self.map_info[tostring(region)][tostring(city)]["capture_zone"]["y"], 0)
end

function MapManager:GetCityRangedSpawnPoint(region, city)
	return self:GetCityMeleeSpawnPoint(region, city) + Vector(-192, 192, 0)
end

function MapManager:GetCityCaptureZoneCenter(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["capture_zone"]["x"], self.map_info[tostring(region)][tostring(city)]["capture_zone"]["y"], self.map_info[tostring(region)][tostring(city)]["capture_zone"]["height"])
end

function MapManager:GetCityCaptureZoneRadius(region, city)
	return self.map_info[tostring(region)][tostring(city)]["capture_zone"]["radius"]
end

function MapManager:GetBeastSpawnPoint(region)
	return Vector(self.neutrals_map_info["beast_spawns"][tostring(region)]["x"], self.neutrals_map_info["beast_spawns"][tostring(region)]["y"], 0)
end

function MapManager:GetBeastSpawner(region)
	return self.regional_spawners[region].spawner
end

function MapManager:GetCityByNumber(region, city)
	return self.cities[region][city]
end

function MapManager:GetTowerByNumber(region, city)
	return self.towers[region][city]
end

function MapManager:GetTowerBaseByNumber(region, city)
	return self.tower_bases[region][city]
end

function MapManager:SetRallyPoint(region, city, target_loc)
	self.rally_points[region][city] = target_loc
end

function MapManager:GetRallyPoint(region, city)
	return self.rally_points[region][city]
end

function MapManager:ClearRallyPoint(region, city)
	self.rally_points[region][city] = nil
end

function MapManager:SetPortalRallyPoint(portal, target_loc)
	self.demon_portals[portal]["rally_point"] = target_loc
end

function MapManager:GetPortalRallyPoint(portal)
	return self.demon_portals[portal]["rally_point"]
end

function MapManager:ClearPortalRallyPoint(portal)
	self.demon_portals[portal]["rally_point"] = nil
end



-- City ownership
function MapManager:GetCityOwner(region, city)
	return self.city_owners[region][city]
end

function MapManager:SetCityOwner(region, city, player)
	self.city_owners[region][city] = player
end

function MapManager:IsRegionOwner(region, player)
	return self.player_sovereign_regions[player][region]
end

function MapManager:IsRegionContender(region, player)
	return self.player_contender_regions[player][region]
end

function MapManager:SetRegionOwner(region, player, value)
	if region == 5 and value then
		MapManager:AddModifierToAllPlayerCities(player, "modifier_kingdom_r5_owner")
	elseif region == 5 and (not value) then
		MapManager:RemoveModifierFromAllCities(player, "modifier_kingdom_r5_owner")
	end

	if value and self:GetBeastSpawner(region) then
		local player_color = Kingdom:GetKingdomPlayerColor(player)
		self:GetBeastSpawner(region):SetRenderColor(player_color.x, player_color.y, player_color.z)
	end

	if (not value) and self:GetBeastSpawner(region) then
		self:GetBeastSpawner(region):SetRenderColor(255, 255, 255)
	end

	self.player_sovereign_regions[player][region] = value
end

function MapManager:SetRegionContender(region, player, value)
	if region == 1 and value then
		MapManager:AddModifierToAllPlayerCities(player, "modifier_kingdom_r1_contender")
	elseif region == 1 and (not value) then
		MapManager:RemoveModifierFromAllCities(player, "modifier_kingdom_r1_contender")
	elseif region == 2 and value then
		MapManager:AddModifierToAllPlayerCities(player, "modifier_kingdom_r2_contender")
	elseif region == 2 and (not value) then
		MapManager:RemoveModifierFromAllCities(player, "modifier_kingdom_r2_contender")
	elseif region == 5 and value then
		MapManager:AddModifierToAllPlayerCities(player, "modifier_kingdom_r5_contender")
	elseif region == 5 and (not value) then
		MapManager:RemoveModifierFromAllCities(player, "modifier_kingdom_r5_contender")
	elseif region == 6 and value then
		MapManager:AddModifierToAllPlayerCities(player, "modifier_kingdom_r6_contender")
	elseif region == 6 and (not value) then
		MapManager:RemoveModifierFromAllCities(player, "modifier_kingdom_r6_contender")
	end

	self.player_contender_regions[player][region] = value
end

function MapManager:GetPlayerCityCount(player)
	local city_count = 0
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			if self:GetCityOwner(region, city) == player then
				city_count = city_count + 1
			end
		end
	end
	return city_count
end

function MapManager:GetPlayerRegionCount(player)
	return self.player_region_count[player]
end

function MapManager:GetPlayerCityCountInRegion(player, region)
	local city_count = 0
	for city = 1, self:GetRegionCityCount(region) do
		if self:GetCityOwner(region, city) == player then
			city_count = city_count + 1
		end
	end
	return city_count
end

function MapManager:AddModifierToAllPlayerCities(player, modifier_name)
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			if self:GetCityOwner(region, city) == player then
				local city_unit = self:GetCityByNumber(region, city)
				city_unit:AddNewModifier(city_unit, nil, modifier_name, {})
			end
		end
	end
end

function MapManager:RemoveModifierFromAllCities(player, modifier_name)
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			if self:GetCityOwner(region, city) == player then
				self:GetCityByNumber(region, city):RemoveModifierByName(modifier_name)
			end
		end
	end
end

function MapManager:UpdatePlayerCityCounts()

	-- Reset counts
	for player = 1, Kingdom:GetPlayerCount() do
		self.player_region_count[player] = 0
		self.player_city_count[player] = 0
		for region = 1, self:GetRegionCount() do
			self.player_city_count_by_region[player][region] = 0
		end
	end

	-- Count
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			local city_owner = self:GetCityOwner(region, city)
			self.player_city_count[city_owner] = self.player_city_count[city_owner] + 1
			self.player_city_count_by_region[city_owner][region] = self.player_city_count_by_region[city_owner][region] + 1
		end

		for player = 1, Kingdom:GetPlayerCount() do

			-- Regional bonuses
			if self.player_city_count_by_region[player][region] >= self:GetRegionCityCount(region) then
				if not self:IsRegionOwner(region, player) then
					local event = {}
					local player_id = Kingdom:GetPlayerID(player)
					event.playerid = player_id
					event.playername = PlayerResource:GetPlayerName(player_id)
					event.steamid = PlayerResource:GetSteamID(player_id)
					event.regionname = "#region_"..region
					CustomGameEventManager:Send_ServerToAllClients("kingdom_new_region_sovereign", {event})
					self:SetRegionOwner(region, player, true)
				end
				if not self:IsRegionContender(region, player) then
					self:SetRegionContender(region, player, true)
				end
				self.player_region_count[player] = self.player_region_count[player] + 1

			elseif self.player_city_count_by_region[player][region] >= (self:GetRegionCityCount(region) * 0.5) then
				if self:IsRegionOwner(region, player) then
					local event = {}
					local player_id = Kingdom:GetPlayerID(player)
					event.playerid = player_id
					event.playername = PlayerResource:GetPlayerName(player_id)
					event.steamid = PlayerResource:GetSteamID(player_id)
					event.regionname = "#region_"..region
					CustomGameEventManager:Send_ServerToAllClients("kingdom_lost_region_sovereign", {event})
					self:SetRegionOwner(region, player, false)
				elseif not self:IsRegionContender(region, player) then
					local event = {}
					local player_id = Kingdom:GetPlayerID(player)
					event.playerid = player_id
					event.playername = PlayerResource:GetPlayerName(player_id)
					event.steamid = PlayerResource:GetSteamID(player_id)
					event.regionname = "#region_"..region
					CustomGameEventManager:Send_ServerToAllClients("kingdom_new_region_contender", {event})
					self:SetRegionContender(region, player, true)
				end

			else
				if self:IsRegionContender(region, player) then
					local event = {}
					local player_id = Kingdom:GetPlayerID(player)
					event.playerid = player_id
					event.playername = PlayerResource:GetPlayerName(player_id)
					event.steamid = PlayerResource:GetSteamID(player_id)
					event.regionname = "#region_"..region
					CustomGameEventManager:Send_ServerToAllClients("kingdom_lost_region_contender", {event})
					self:SetRegionContender(region, player, false)
				end

				if self:IsRegionOwner(region, player) then
					self:SetRegionOwner(region, player, false)
				end
			end
		end
	end

	-- Update ownership table
	local region_info = {}
	region_info.owners = {}
	region_info.contenders = {}

	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		region_info.owners[player_id] = {}
		region_info.contenders[player_id] = {}
		for region = 1, self:GetRegionCount() do
			region_info.owners[player_id][region] = self:IsRegionOwner(region, player)
			region_info.contenders[player_id][region] = self:IsRegionContender(region, player)
		end
	end

	CustomNetTables:SetTableValue("region_info", "region_owners", region_info)

	-- Update scoreboard
	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		CustomNetTables:SetTableValue("player_info", "player_cities_"..player_id, {city_amount = self.player_city_count[player]})

		-- If any players were eliminated, send a notification
		if self.player_city_count[player] <= 0 and (not self.player_eliminated[player]) and EconomyManager.turn_count and EconomyManager.turn_count > 0 then
			local event = {}
			event.playerid = player_id
			event.playername = PlayerResource:GetPlayerName(player_id)
			event.steamid = PlayerResource:GetSteamID(player_id)
			event.position = self.players_remaining
			CustomGameEventManager:Send_ServerToAllClients("kingdom_player_eliminated", {event})

			self.player_eliminated[player] = true
			self.players_remaining = self.players_remaining - 1
		end
	end

	-- Check for overtime win
	if EconomyManager:IsOvertime() then
		EconomyManager:EndGameByRoundLimit()
	
	-- Check for domination win
	else
		for player = 1, Kingdom:GetPlayerCount() do
			local player_id = Kingdom:GetPlayerID(player)

			if self.player_city_count[player] >= 48 then
				if not IsInToolsMode() then
					Kingdom:SetWinner(player)
				end
			end

			if self.player_city_count[player] >= 47 and (not self.is_very_near_win[player]) then
				self.is_very_near_win[player] = true

				local event = {}
				event.playerid = player_id
				event.playername = PlayerResource:GetPlayerName(player_id)
				event.steamid = PlayerResource:GetSteamID(player_id)
				CustomGameEventManager:Send_ServerToAllClients("kingdom_player_very_near_win", {event})
			end

			if self.player_city_count[player] < 47 then
				self.is_very_near_win[player] = false
			end

			if self.player_city_count[player] >= 43 and (not self.is_near_win[player]) then
				self.is_near_win[player] = true

				local event = {}
				event.playerid = player_id
				event.playername = PlayerResource:GetPlayerName(player_id)
				event.steamid = PlayerResource:GetSteamID(player_id)
				CustomGameEventManager:Send_ServerToAllClients("kingdom_player_near_win", {event})
			end

			if self.player_city_count[player] < 43 then
				self.is_near_win[player] = false
			end
		end
	end
end

function MapManager:SetCityControllable(region, city, player)
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local city_unit = self:GetCityByNumber(region, city)
	local tower_unit = self:GetTowerByNumber(region, city)
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	city_unit:SetOwner(player_hero)
	city_unit:SetControllableByPlayer(player_id, true)
	tower_unit:SetOwner(player_hero)
	tower_unit:SetControllableByPlayer(player_id, true)
	self:GetTowerBaseByNumber(region, city):SetRenderColor(player_color.x, player_color.y, player_color.z)
end

function MapManager:SetPortalControllable(portal, player)
	local player_id = Kingdom:GetPlayerID(player)
	local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local city_unit = self.demon_portals[portal]["portal"]
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	city_unit:SetOwner(player_hero)
	city_unit:SetControllableByPlayer(player_id, true)
end

function MapManager:StartCaptureTracking(region, city)
	Timers:CreateTimer(0, function()
		local owner_player = self:GetCityOwner(region, city)
		local city_team = PlayerResource:GetTeam(Kingdom:GetPlayerID(owner_player))
		local start_point = self:GetCityCaptureZoneCenter(region, city)
		local allies = FindUnitsInRadius(city_team, start_point, nil, 192, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local enemies = FindUnitsInRadius(city_team, start_point, nil, 192, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local attacking_player = 0

		if #enemies > 0 then
			attacking_player = Kingdom:GetPlayerByTeam(enemies[1]:GetTeam())
		end

		if attacking_player then
			self:ProcessCapture(region, city, #allies, #enemies, attacking_player, owner_player)
		end
		return 0.25
	end)
end

function MapManager:ProcessCapture(region, city, ally_count, enemy_count, attacking_player, owner_player)

	-- If there are both allies and enemies in the capture point, nothing changes
	if ally_count > 0 and enemy_count > 0 then
		return nil
	end

	-- If a capture attempt is starting, initialize it
	local owner_color = Kingdom:GetKingdomPlayerColor(owner_player)
	local attacker_color = Kingdom:GetKingdomPlayerColor(attacking_player)
	if enemy_count > 0 and not self.capture_info[region][city].status then
		self.capture_info[region][city].status = true
		self.capture_info[region][city].progress = 0
		self.capture_info[region][city].particle = self:DrawCaptureParticle(self:GetCityCaptureZoneCenter(region, city) + Vector(0, 0, 400), 0, Vector(owner_color.x, owner_color.y, owner_color.z))
		self:PingMinimap(region, city)
	-- If a capture attempt is in progress, continue with it
	elseif enemy_count > 0 and self.capture_info[region][city].status then
		local city_level = self:GetCityByNumber(region, city):GetLevel()

		-- Capture progress
		local capture_time = self.city_capture_time[city_level]
		if self:IsCapital(region, city) then
			capture_time = capture_time + self.capital_capture_time
		end

		self.capture_info[region][city].progress = self.capture_info[region][city].progress + 0.25 / capture_time

		local ring_color = self.capture_info[region][city].progress * Vector(attacker_color.x, attacker_color.y, attacker_color.z) + (1 - self.capture_info[region][city].progress) * Vector(owner_color.x, owner_color.y, owner_color.z)
		ParticleManager:DestroyParticle(self.capture_info[region][city].particle, false)
		ParticleManager:ReleaseParticleIndex(self.capture_info[region][city].particle)
		self.capture_info[region][city].particle = self:DrawCaptureParticle(self:GetCityCaptureZoneCenter(region, city) + Vector(0, 0, 400), self.capture_info[region][city].progress, ring_color)

		if self.capture_info[region][city].progress >= 1 then
			ParticleManager:DestroyParticle(self.capture_info[region][city].particle, false)
			ParticleManager:ReleaseParticleIndex(self.capture_info[region][city].particle)
			self.capture_info[region][city].particle = nil
			self.capture_info[region][city].status = false
			self.capture_info[region][city].progress = 0

			self:CaptureCity(region, city, attacking_player)
			self:RazeCity(region, city)
			EconomyManager:UpdateIncomeForPlayer(attacking_player)
			EconomyManager:UpdateIncomeForPlayer(owner_player)

			print(region..", "..city.." city captured by player"..attacking_player)
			return nil
		end
	end

	-- If a capture attempt has failed, end it
	if enemy_count <= 0 and self.capture_info[region][city].status then
		ParticleManager:DestroyParticle(self.capture_info[region][city].particle, false)
		ParticleManager:ReleaseParticleIndex(self.capture_info[region][city].particle)
		self.capture_info[region][city].particle = nil
		self.capture_info[region][city].status = false
		self.capture_info[region][city].progress = 0
		return nil
	end
end

function MapManager:StartPortalCaptureTracking(portal)
	Timers:CreateTimer(0, function()
		local portal_handle = self.demon_portals[portal]["portal"]
		local owner_player = self.demon_portals[portal]["owner_player"]
		local city_team = DOTA_TEAM_NEUTRALS
		if owner_player > 0 then
			city_team = PlayerResource:GetTeam(Kingdom:GetPlayerID(owner_player))
		end
		local start_point = self.demon_portals[portal]["capture_point"]

		local allies = FindUnitsInRadius(city_team, start_point, nil, 192, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local enemies = FindUnitsInRadius(city_team, start_point, nil, 192, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local attacking_player = 0

		if #enemies > 0 then
			attacking_player = Kingdom:GetPlayerByTeam(enemies[1]:GetTeam())
		end

		if attacking_player then
			self:ProcessPortalCapture(portal, #allies, #enemies, attacking_player, owner_player)
		end
		return 0.25
	end)
end

function MapManager:ProcessPortalCapture(portal, ally_count, enemy_count, attacking_player, owner_player)

	-- If there are both allies and enemies in the capture point, nothing changes
	if ally_count > 0 and enemy_count > 0 then
		return nil
	end

	-- If a capture attempt is starting, initialize it
	local owner_color = Vector(0, 0, 0)
	if owner_player > 0 then
		owner_color = Kingdom:GetKingdomPlayerColor(owner_player)
	end
	local attacker_color = Kingdom:GetKingdomPlayerColor(attacking_player)
	if enemy_count > 0 and not self.demon_portals[portal]["capture_info"].status then
		self.demon_portals[portal]["capture_info"].status = true
		self.demon_portals[portal]["capture_info"].progress = 0
		self.demon_portals[portal]["capture_info"].particle = self:DrawCaptureParticle(self.demon_portals[portal]["capture_point"] + Vector(0, 0, 400), 0, Vector(owner_color.x, owner_color.y, owner_color.z))
		self:PingPortalMinimap(portal)

	-- If a capture attempt is in progress, continue with it
	elseif enemy_count > 0 and self.demon_portals[portal]["capture_info"].status then
		local portal_level = self.demon_portals[portal]["portal"]:GetLevel()

		-- Capture progress
		self.demon_portals[portal]["capture_info"].progress = self.demon_portals[portal]["capture_info"].progress + 0.25 / self.city_capture_time[portal_level]

		local ring_color = self.demon_portals[portal]["capture_info"].progress * Vector(attacker_color.x, attacker_color.y, attacker_color.z) + (1 - self.demon_portals[portal]["capture_info"].progress) * Vector(owner_color.x, owner_color.y, owner_color.z)
		ParticleManager:DestroyParticle(self.demon_portals[portal]["capture_info"].particle, false)
		ParticleManager:ReleaseParticleIndex(self.demon_portals[portal]["capture_info"].particle)
		self.demon_portals[portal]["capture_info"].particle = self:DrawCaptureParticle(self.demon_portals[portal]["capture_point"] + Vector(0, 0, 400), self.demon_portals[portal]["capture_info"].progress, ring_color)

		if self.demon_portals[portal]["capture_info"].progress >= 1 then
			ParticleManager:DestroyParticle(self.demon_portals[portal]["capture_info"].particle, false)
			ParticleManager:ReleaseParticleIndex(self.demon_portals[portal]["capture_info"].particle)
			self.demon_portals[portal]["capture_info"].particle = nil
			self.demon_portals[portal]["capture_info"].status = false
			self.demon_portals[portal]["capture_info"].progress = 0

			self:CapturePortal(portal, attacking_player)
			EconomyManager:UpdateIncomeForPlayer(attacking_player)
			if owner_player > 0 then
				EconomyManager:UpdateIncomeForPlayer(owner_player)
			end

			print(portal.." demon portal captured by player"..attacking_player)
			return nil
		end
	end

	-- If a capture attempt has failed, end it
	if enemy_count <= 0 and self.demon_portals[portal]["capture_info"].status then
		ParticleManager:DestroyParticle(self.demon_portals[portal]["capture_info"].particle, false)
		ParticleManager:ReleaseParticleIndex(self.demon_portals[portal]["capture_info"].particle)
		self.demon_portals[portal]["capture_info"].particle = nil
		self.demon_portals[portal]["capture_info"].status = false
		self.demon_portals[portal]["capture_info"].progress = 0
		return nil
	end
end

function MapManager:CaptureCity(region, city, player)
	local team = Kingdom:GetKingdomPlayerTeam(player)
	local city_unit = self:GetCityByNumber(region, city)

	city_unit:Stop()
	city_unit:SetTeam(team)
	self:SetCityOwner(region, city, player)
	self:SetCityControllable(region, city, player)
	self:GetTowerByNumber(region, city):SetTeam(team)
	self:ClearRallyPoint(region, city)

	-- Update regional bonuses
	city_unit:RemoveModifierByName("modifier_kingdom_r5_owner")
	city_unit:RemoveModifierByName("modifier_kingdom_r1_contender")
	city_unit:RemoveModifierByName("modifier_kingdom_r2_contender")
	city_unit:RemoveModifierByName("modifier_kingdom_r5_contender")
	city_unit:RemoveModifierByName("modifier_kingdom_r6_contender")

	if self:IsRegionOwner(5, player) then
		city_unit:AddNewModifier(city_unit, nil, "modifier_kingdom_r5_owner", {})
	end
	if self:IsRegionContender(1, player) then
		city_unit:AddNewModifier(city_unit, nil, "modifier_kingdom_r1_contender", {})
	end
	if self:IsRegionContender(2, player) then
		city_unit:AddNewModifier(city_unit, nil, "modifier_kingdom_r2_contender", {})
	end
	if self:IsRegionContender(5, player) then
		city_unit:AddNewModifier(city_unit, nil, "modifier_kingdom_r5_contender", {})
	end
	if self:IsRegionContender(6, player) then
		city_unit:AddNewModifier(city_unit, nil, "modifier_kingdom_r6_contender", {})
	end

	self:UpdatePlayerCityCounts()
end

function MapManager:CapturePortal(portal, player)
	local team = Kingdom:GetKingdomPlayerTeam(player)
	self.demon_portals[portal]["owner_player"] = player
	self:SetPortalControllable(portal, player)
	self.demon_portals[portal]["portal"]:SetTeam(team)
	self:ClearPortalRallyPoint(portal)

	self:UpdatePlayerCityCounts()
end

function MapManager:DrawCaptureParticle(position, progress, color)
	local particle = ParticleManager:CreateParticle("particles/capture_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, position)
	ParticleManager:SetParticleControl(particle, 1, Vector(200, progress, 0))
	ParticleManager:SetParticleControl(particle, 15, color)
	ParticleManager:SetParticleControl(particle, 16, Vector(1, 0, 0))
	return particle
end

-- City upgrades
function MapManager:RazeCity(region, city)
	local city_unit = self:GetCityByNumber(region, city)
	local tower_unit = self:GetTowerByNumber(region, city)
	local player_color = Kingdom:GetKingdomPlayerColor(MapManager:GetCityOwner(region, city))

	if city_unit:GetLevel() == 3 then
		city_unit:CreatureLevelUp(-1)
		tower_unit:CreatureLevelUp(-1)

		-- Remove level 3 effects
		ParticleManager:DestroyParticle(city_unit.level_3_pfx, false)
		ParticleManager:ReleaseParticleIndex(city_unit.level_3_pfx)

		-- Re-add level 2 effects
		city_unit.level_2_pfx = ParticleManager:CreateParticle("particles/upgraded_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(city_unit.level_2_pfx, 0, city_unit:GetAbsOrigin() + Vector(0, 0, 10))
		ParticleManager:SetParticleControl(city_unit.level_2_pfx, 1, player_color)

		-- Adjust abilities
		local next_ability = city_unit:AddAbility("kingdom_upgrade_city_3")
		next_ability:SetLevel(1)

		if not self:IsCapital(region, city) then
			next_ability:SetActivated(false)
		end

		city_unit:RemoveAbility("kingdom_city_3")
		city_unit:AddAbility("kingdom_city_2"):SetLevel(1)

	elseif city_unit:GetLevel() == 2 then
		city_unit:CreatureLevelUp(-1)
		tower_unit:CreatureLevelUp(-1)

		-- Remove level 2 effects
		ParticleManager:DestroyParticle(city_unit.level_2_pfx, false)
		ParticleManager:ReleaseParticleIndex(city_unit.level_2_pfx)

		-- Adjust abilities
		city_unit:RemoveAbility("kingdom_upgrade_city_3")
		city_unit:AddAbility("kingdom_upgrade_city_2"):SetLevel(1)
		city_unit:RemoveAbility("kingdom_city_2")
		city_unit:AddAbility("kingdom_city_1"):SetLevel(1)
	end

	-- Update capital particle
	if self:IsCapital(region, city) then
		ParticleManager:DestroyParticle(city_unit.capital_pfx, false)
		ParticleManager:ReleaseParticleIndex(city_unit.capital_pfx)

		city_unit.capital_pfx = ParticleManager:CreateParticle("particles/capital_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(city_unit.capital_pfx, 0, city_unit:GetAbsOrigin() + Vector(0, 0, 10))
		ParticleManager:SetParticleControl(city_unit.capital_pfx, 1, player_color)
	end
end

function MapManager:UpgradeCity(region, city)
	local city_unit = self:GetCityByNumber(region, city)
	local tower_unit = self:GetTowerByNumber(region, city)
	city_unit:CreatureLevelUp(1)
	tower_unit:CreatureLevelUp(1)
end

function MapManager:UpgradeCapitalTower(region, city)
	local tower_unit = self:GetTowerByNumber(region, city)
	tower_unit:AddNewModifier(tower_unit, nil, "modifier_kingdom_capital_tower", {})
end

function MapManager:PingMinimap(region, city)
	local player_owner = self:GetCityOwner(region, city)
	if player_owner then
		local player_id = Kingdom:GetPlayerID(player_owner)
		if player_id and PlayerResource:GetPlayer(player_id) then
			local ping_location = self:GetCityOrigin(region, city)
			local ping_height = self:GetCityCaptureZoneCenter(region, city).z
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "kingdom_minimap_ping", {x = ping_location.x, y = ping_location.y, z = ping_height})
		end
	end
end

function MapManager:PingPortalMinimap(portal)
	local player_owner = self.demon_portals[portal]["owner_player"]
	if player_owner then
		local player_id = Kingdom:GetPlayerID(player_owner)
		if player_id and PlayerResource:GetPlayer(player_id) then
			local ping_location = self.demon_portals[portal]["portal"]:GetAbsOrigin()
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "kingdom_minimap_ping", {x = ping_location.x, y = ping_location.y, z = ping_location.z})
		end
	end
end



-- Spawners
function MapManager:SpawnTower(region, city)
	local race = self:GetCityRace(region, city)
	local tower_loc = self:GetCityTowerSpawnPoint(region, city)
	local player = self:GetCityOwner(region, city)
	local tower_name = "npc_kingdom_tower_"..race
	local player_id = Kingdom:GetPlayerID(player)
	local player_color = Kingdom:GetKingdomPlayerColor(player)

	-- Spawn tower
	local tower = CreateUnitByName(tower_name, Vector(tower_loc.x, tower_loc.y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	tower:FaceTowards(tower:GetAbsOrigin() + Vector(0, -100, 0))
	tower:AddNewModifier(tower, nil, "modifier_kingdom_tower", {})

	-- Spawn tower base
	local base = CreateUnitByName("npc_kingdom_tower_base", Vector(tower_loc.x, tower_loc.y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	base:AddNewModifier(base, nil, "modifier_kingdom_tower_base", {})
	base:SetRenderColor(player_color.x, player_color.y, player_color.z)	

	-- Tower meta-information
	self.towers[region][city] = tower
	self.tower_bases[region][city] = base
	tower.region = region
	tower.city = city
	base.region = region
	base.city = city

	-- Race-specific stuff
	if race == "orc" then
		tower:SetRenderColor(74, 59, 65)
	end
	if race == "human" then
		tower:SetAbsOrigin(tower:GetAbsOrigin() - Vector(0, 0, 35))
	end
	if race == "undead" then
		tower:SetAbsOrigin(tower:GetAbsOrigin() - Vector(0, 0, 35))
	end
end

function MapManager:SpawnCity(region, city)
	local city_loc = self:GetCityOrigin(region, city)
	local angle = self:GetCityFacing(region, city)
	local race = self:GetCityRace(region, city)
	local hero = self:GetCityHero(region, city)
	local player = self:GetCityOwner(region, city)
	local city_name = "npc_kingdom_city_"..region.."_"..city
	local player_id = Kingdom:GetPlayerID(player)
	local facing_position = RotatePosition(Vector(city_loc.x, city_loc.y, 0), QAngle(0, angle, 0), Vector(city_loc.x, city_loc.y, 0) + Vector(100, 0, 0))

	-- Spawn city
	local unit = CreateUnitByName(city_name, Vector(city_loc.x, city_loc.y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	unit:FaceTowards(facing_position)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_city", {})
	unit:AddNewModifier(unit, nil, "modifier_kingdom_city_pregame", {})

	-- Add hero spawning ability, if applicable
	if hero then
		unit:RemoveAbility("generic_hidden")
		unit:AddAbility("kingdom_buy_hero_"..hero):SetLevel(1)
	end

	-- Tower meta-information
	self.cities[region][city] = unit
	unit.region = region
	unit.city = city

	-- Race-specific stuff
	if race == "orc" then
		unit:SetRenderColor(74, 59, 65)
	elseif race == "undead" then
		unit:AddNewModifier(unit, nil, "modifier_kingdom_undead_city_animation", {})
	elseif race == "keen" then
		unit:AddNewModifier(unit, nil, "modifier_kingdom_keen_city_animation", {})
	end
end

function MapManager:SpawnCapital(region, city)
	local city_loc = MapManager:GetCityOrigin(region, city)
	local angle = MapManager:GetCityFacing(region, city)
	local race = MapManager:GetCityRace(region, city)
	local hero = MapManager:GetCityHero(region, city)
	local player = MapManager:GetCityOwner(region, city)
	local city_name = "npc_kingdom_city_"..region.."_"..city.."_capital"
	local player_id = Kingdom:GetPlayerID(player)
	local facing_position = RotatePosition(Vector(city_loc.x, city_loc.y, 0), QAngle(0, angle, 0), Vector(city_loc.x, city_loc.y, 0) + Vector(100, 0, 0))

	-- Spawn city
	local unit = CreateUnitByName(city_name, Vector(city_loc.x, city_loc.y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	unit:FaceTowards(facing_position)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_city", {})
	unit:AddNewModifier(unit, nil, "modifier_kingdom_city_pregame", {})

	-- Add hero spawning ability, if applicable
	if hero then
		unit:RemoveAbility("generic_hidden")
		unit:AddAbility("kingdom_buy_hero_"..hero):SetLevel(1)
	end

	-- Tower meta-information
	MapManager.cities[region][city] = unit
	unit.region = region
	unit.city = city

	-- Race-specific stuff
	if race == "orc" then
		unit:SetRenderColor(74, 59, 65)
	elseif race == "undead" then
		unit:AddNewModifier(unit, nil, "modifier_kingdom_undead_city_animation", {})
	elseif race == "keen" then
		unit:AddNewModifier(unit, nil, "modifier_kingdom_keen_city_animation", {})
	end
end

-- Requires n regions with n cities each, to be distributed amongst n players
function MapManager:PerformInitialCityDistribution()
	local player_count = Kingdom:GetPlayerCount()
	local city_count = {}
	for player = 1, player_count do
		city_count[player] = {}
	end

	-- If there are less than 8 players, perform simplified distribution
	if player_count < 8 then
		local current_player = 1
		local remaining_cities = {}
		for region = 1, self:GetRegionCount() do
			for city = 1, self:GetRegionCityCount(region) do
				table.insert(remaining_cities, region..city)
			end
		end

		while #remaining_cities > 0 do
			local rand = RandomInt(1, #remaining_cities)
			local region = tonumber(string.sub(remaining_cities[rand], 1, 1))
			local city = tonumber(string.sub(remaining_cities[rand], 2, 2))
			self:SetCityOwner(region, city, current_player)
			table.remove(remaining_cities, rand)
			current_player = current_player + 1
			if current_player > player_count then
				current_player = 1
			end
		end

		return nil
	end

	-- Give each player one city per region
	for region = 1, self:GetRegionCount() do
		local remaining_region_players = {}
		for player = 1, player_count do
			remaining_region_players[player] = player
			city_count[player][region] = 0
		end
		for city, owner in pairs(self.city_owners[region]) do
			local random_player = remaining_region_players[RandomInt(1, #remaining_region_players)]
			self:SetCityOwner(region, city, random_player)
			city_count[random_player][region] = city_count[random_player][region] + 1
			for player_key, player in pairs(remaining_region_players) do
				if player == random_player then
					table.remove(remaining_region_players, player_key)
				end
			end
		end
	end

	-- Perform several random swaps while respecting limits
	local swap_count = 100
	local region_count = self:GetRegionCount()
	local region_max = 2
	local sequential_fails = 0
	while swap_count > 0 do
		local player_1 = RandomInt(1, player_count)
		local player_2 = RandomInt(1, player_count)
		local region_1 = RandomInt(1, region_count)
		local region_2 = RandomInt(1, region_count)
		if city_count[player_1][region_1] > 0 and city_count[player_2][region_1] < region_max and city_count[player_1][region_2] < region_max and city_count[player_2][region_2] > 0 then
			swap_count = swap_count - 1
			sequential_fails = 0
			city_count[player_1][region_1] = city_count[player_1][region_1] - 1
			city_count[player_2][region_1] = city_count[player_2][region_1] + 1
			city_count[player_1][region_2] = city_count[player_1][region_2] + 1
			city_count[player_2][region_2] = city_count[player_2][region_2] - 1
			--print("swaps remaining: "..swap_count)
			for city, owner in pairs(self.city_owners[region_1]) do
				if owner == player_1 then
					--print("swapped city "..city.." from region "..region_1.." from player "..player_1.." to player "..player_2)
					self:SetCityOwner(region_1, city, player_2)
					break
				end
			end
			for city, owner in pairs(self.city_owners[region_2]) do
				if owner == player_2 then
					--print("swapped city "..city.." from region "..region_2.." from player "..player_2.." to player "..player_1)
					self:SetCityOwner(region_2, city, player_1)
					break
				end
			end
		else
			--print("swap failed! trying again")
			sequential_fails = sequential_fails + 1
		end

		if sequential_fails >= 10 then
			--print("too many swap failures, stopping")
			swap_count = 0
		end
	end
end

function MapManager:SpawnRegionalSpawners()
	for region = 1, self:GetRegionCount() do
		local location = self:GetBeastSpawnPoint(region)
		local spawner = CreateUnitByName("npc_kingdom_regional_spawner", GetGroundPosition(location + Vector(0, 256, 0), spawner), false, nil, nil, DOTA_TEAM_NEUTRALS)

		spawner:AddNewModifier(spawner, nil, "modifier_kingdom_tower_base", {})
		spawner:SetAbsOrigin(GetGroundPosition(spawner:GetAbsOrigin(), spawner))

		self.regional_spawners[region].spawner = spawner
	end
end

function MapManager:SpawnDemonPortals()
	local remaining_regions = {1, 2, 3, 4, 5, 6, 7, 8}
	local army_commanders = {}
	army_commanders[1] = "doom"
	army_commanders[2] = "duchess"
	army_commanders[3] = "nevermore"

	-- Pick random portal locations, never from the same region
	for i = 1, self:GetDemonPortalCount() do
		local chosen_region = RandomInt(1, #remaining_regions)
		self.demon_portals[i] = self:SpawnDemonPortalAt(remaining_regions[chosen_region], RandomInt(1, 2), army_commanders[i])
		self.demon_portals[i]["portal"].portal_number = i
		table.remove(remaining_regions, chosen_region)
	end
end

function MapManager:SpawnDemonPortalAt(region, location, commander_name)
	local portal_info = self.neutrals_map_info["demon_portals"][tostring(region)][tostring(location)]
	local portal_loc = Vector(portal_info["city"]["x"], portal_info["city"]["y"], portal_info["city"]["z"])
	local angle = portal_info["city"]["angle"]
	local facing_position = RotatePosition(Vector(portal_loc.x, portal_loc.y, 0), QAngle(0, angle, 0), Vector(portal_loc.x, portal_loc.y, 0) + Vector(100, 0, 0))

	-- Spawn portal
	local portal = CreateUnitByName("npc_kingdom_city_demon", Vector(portal_loc.x, portal_loc.y, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
	portal:AddNewModifier(portal, nil, "modifier_kingdom_city", {})
	portal:FaceTowards(facing_position)
	portal:SetRenderColor(0, 0, 0)
	portal:CreatureLevelUp(2)
	Timers:CreateTimer(0.5, function()
		portal:SetAbsOrigin(portal_loc)
	end)

	-- Active portal effect
	portal.portal_pfx = ParticleManager:CreateParticle("particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(portal.portal_pfx, 0, portal_loc + Vector(0, 0, 475))
	ParticleManager:SetParticleControl(portal.portal_pfx, 6, portal_loc + Vector(0, 0, 450))
	ParticleManager:SetParticleControl(portal.portal_pfx, 60, Vector(RandomInt(0, 255), RandomInt(0, 50), RandomInt(0, 255)))
	ParticleManager:SetParticleControl(portal.portal_pfx, 61, Vector(1, 0, 0))

	-- Spawn demon army
	local army_loc = Vector(portal_info["capture_zone"]["x"], portal_info["capture_zone"]["y"], 0)
	self:SpawnDemonArmy(army_loc, commander_name)

	local units = {}
	units["portal"] = portal
	units["capture_point"] = Vector(portal_info["capture_zone"]["x"], portal_info["capture_zone"]["y"], portal_info["capture_zone"]["height"])
	units["capture_info"] = {}
	units["owner_player"] = 0

	return units
end

function MapManager:SpawnDemonArmy(location, commander_name)

	local commander = CreateUnitByName("npc_kingdom_hero_"..commander_name, location, true, nil, nil, DOTA_TEAM_NEUTRALS)
	commander:SetHullRadius(48)

	Timers:CreateTimer(10, function()
		commander:AddNewModifier(commander, nil, "modifier_kingdom_demon_hero_marker", {ability_name = "kingdom_buy_hero_"..commander_name})
		commander:AddNewModifier(commander, nil, "modifier_kingdom_unit_movement", {})
		commander:AddNewModifier(commander, nil, "modifier_kingdom_demon_spawn_leash", {})
	end)

	local melee_positions = {}
	melee_positions[1] = Vector(-200, -150, 0)
	melee_positions[2] = Vector(-67, -150, 0)
	melee_positions[3] = Vector(67, -150, 0)
	melee_positions[4] = Vector(200, -150, 0)

	for i = 1, 4 do
		local unit = CreateUnitByName("npc_kingdom_demon_melee", location + melee_positions[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit.type = KINGDOM_UNIT_TYPE_MELEE
		unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
		unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {})
		unit:AddNewModifier(unit, nil, "modifier_kingdom_demon_spawn_leash", {})
	end

	local ranged_positions = {}
	ranged_positions[1] = Vector(-250, 0, 0)
	ranged_positions[2] = Vector(0, 0, 0)
	ranged_positions[3] = Vector(250, 0, 0)

	for i = 1, 3 do
		local unit = CreateUnitByName("npc_kingdom_demon_ranged", location + ranged_positions[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit.type = KINGDOM_UNIT_TYPE_RANGED
		unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
		unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {})
		unit:AddNewModifier(unit, nil, "modifier_kingdom_demon_spawn_leash", {})
	end

	local cavalry_positions = {}
	cavalry_positions[1] = Vector(-250, 150, 0)
	cavalry_positions[2] = Vector(0, 150, 0)
	cavalry_positions[3] = Vector(250, 150, 0)

	for i = 1, 3 do
		local unit = CreateUnitByName("npc_kingdom_demon_cavalry", location + cavalry_positions[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit.type = KINGDOM_UNIT_TYPE_CAVALRY
		unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
		unit:AddNewModifier(unit, nil, "modifier_kingdom_unit_movement", {})
		unit:AddNewModifier(unit, nil, "modifier_kingdom_demon_spawn_leash", {})
	end

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(location, 500)
	end)
end