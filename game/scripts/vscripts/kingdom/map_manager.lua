-- Map manager initialization
if MapManager == nil then
	_G.MapManager = class({})
end

-- Map initialization
function MapManager:Init()
	print("--- Map manager: initializing")

	-- Load map information
	self.map_info = LoadKeyValues("scripts/npc/KV/map.kv")

	-- Set up geography constants
	self.city_capture_time = {2, 5, 10}
	self.region_count = 0
	self.city_count = 0
	self.region_city_count = {}

	local region_number = 1
	for _, region in pairs(self.map_info) do
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
	self.region_owners = {}
	self.city_owners = {}
	self.cities = {}
	self.towers = {}
	self.tower_bases = {}
	self.capture_info = {}
	for region = 1, self:GetRegionCount() do
		self.region_owners[region] = 0
		self.city_owners[region] = {}
		self.cities[region] = {}
		self.towers[region] = {}
		self.tower_bases[region] = {}
		self.capture_info[region] = {}
		for city = 1, self:GetRegionCityCount(region) do
			self.city_owners[region][city] = 0
			self.capture_info[region][city] = {}
		end
	end

	-- Distribute cities amongst players randomly
	print("- Map manager: distributing cities amongst players")
	self:PerformInitialCityDistribution()
	PrintTable(self.city_owners)

	-- Spawn towers and cities for each player
	print("- Map manager: spawning cities and towers")
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:SpawnTower(city, region)
			self:SpawnCity(city, region)
		end
	end

	-- Fetch tower base entities
	print("- Map manager: fetching tower base entities")
	local tower_base_entities = Entities:FindAllByModel("models/props_structures/radiant_tower_base002.vmdl")
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			local tower_base_loc = self:GetCityTowerSpawnPoint(region, city)
			for _, tower_base in pairs(tower_base_entities) do
				if (tower_base:GetAbsOrigin() - tower_base_loc):Length2D() < 100 then
					self.tower_bases[region][city] = tower_base
					print("Found tower base entity for "..region..", "..city)
					break
				end
			end
		end
	end

	-- Initialize player city and region count
	self.player_region_count = {}
	self.player_city_count = {}
	self.player_city_count_by_region = {}
	for player_number = 1, Kingdom:GetPlayerCount() do
		self.player_region_count[player_number] = 0
		self.player_city_count[player_number] = 0
		self.player_city_count_by_region[player_number] = {}
		for region = 1, self:GetRegionCount() do
			self.player_city_count_by_region[player_number][region] = 0
		end
	end

	self:UpdatePlayerCityCounts()

	-- Start tracking captures
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:StartCaptureTracking(region, city)
		end
	end

	print("Map manager: finished initializing")
end

-- Map startup (at match start)
function MapManager:StartMatch()
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			self:SetCityControllable(region, city, self:GetCityOwner(region, city))
		end
	end
end

-- Geographical information
function MapManager:GetRegionCount()
	return self.region_count
end

function MapManager:GetCityCount()
	return self.city_count
end

function MapManager:GetRegionCityCount(region)
	return self.region_city_count[region]
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

function MapManager:GetCityByNumber(region, city)
	return self.cities[region][city]
end

function MapManager:GetTowerByNumber(region, city)
	return self.towers[region][city]
end

function MapManager:GetTowerBaseByNumber(region, city)
	return self.tower_bases[region][city]
end



-- City ownership
function MapManager:GetCityOwner(region, city)
	return self.city_owners[region][city]
end

function MapManager:SetCityOwner(region, city, player)
	self.city_owners[region][city] = player
end

function MapManager:GetRegionOwner(region)
	return self.region_owners[region]
end

function MapManager:SetRegionOwner(region, player)
	self.region_owners[region] = player
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
	local region_count = 0
	for region = 1, self:GetRegionCount() do
		if self:GetRegionOwner(region) == player then
			region_count = region_count + 1
		end
	end
	return region_count
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
		self.region_owners[region] = 0
		for city = 1, self:GetRegionCityCount(region) do
			local city_owner = self:GetCityOwner(region, city)
			self.player_city_count[city_owner] = self.player_city_count[city_owner] + 1
			self.player_city_count_by_region[city_owner][region] = self.player_city_count_by_region[city_owner][region] + 1
		end
		for player = 1, Kingdom:GetPlayerCount() do
			if self.player_city_count_by_region[player][region] >= self:GetRegionCityCount(region) then
				self.region_owners[region] = player
				self.player_region_count[player] = self.player_region_count[player] + 1
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
	--self:GetTowerBaseByNumber(region, city):SetRenderColor(player_color.x, player_color.y, player_color.z)
end

function MapManager:StartCaptureTracking(region, city)
	Timers:CreateTimer(0, function()
		local owner_player = self:GetCityOwner(region, city)
		local city_team = PlayerResource:GetTeam(Kingdom:GetPlayerID(owner_player))
		local start_point = self:GetCityCaptureZoneCenter(region, city) + Vector(0, -144, 0)
		local end_point = start_point + Vector(0, 288, 0)
		local allies = FindUnitsInLine(city_team, start_point, end_point, nil, 288, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
		local enemies = FindUnitsInLine(city_team, start_point, end_point, nil, 288, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		local attacking_player = 0
		if #enemies > 0 then
			attacking_player = Kingdom:GetPlayerByTeam(enemies[1]:GetTeam())
		end
		self:ProcessCapture(region, city, #allies, #enemies, attacking_player, owner_player)
		return 0.5
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
	-- If a capture attempt is in progress, continue with it
	elseif enemy_count > 0 and self.capture_info[region][city].status then
		local city_level = self:GetCityByNumber(region, city):GetLevel()
		self.capture_info[region][city].progress = self.capture_info[region][city].progress + 0.5 / self.city_capture_time[city_level]

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

function MapManager:CaptureCity(region, city, player)
	local team = Kingdom:GetKingdomPlayerTeam(player)
	self:SetCityOwner(region, city, player)
	self:SetCityControllable(region, city, player)
	self:GetCityByNumber(region, city):SetTeam(team)
	self:GetTowerByNumber(region, city):SetTeam(team)

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



-- Spawners
function MapManager:SpawnTower(city, region)
	local race = self:GetCityRace(region, city)
	local tower_loc = self:GetCityTowerSpawnPoint(region, city)
	local player = self:GetCityOwner(region, city)
	local tower_name = "npc_kingdom_tower_"..race
	local player_id = Kingdom:GetPlayerID(player)

	-- Spawn tower
	local unit = CreateUnitByName(tower_name, Vector(tower_loc.x, tower_loc.y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	--ResolveNPCPositions(Vector(tower_loc.x, tower_loc.y, 0), 128)
	unit:FaceTowards(unit:GetAbsOrigin() + Vector(0, -100, 0))
	unit:AddNewModifier(unit, nil, "modifier_kingdom_tower", {})

	-- Tower meta-information
	self.towers[region][city] = unit
	unit.region = region
	unit.city = city

	-- Race-specific stuff
	if race == "orc" then
		unit:SetRenderColor(74, 59, 65)
	end
end

function MapManager:SpawnCity(city, region)
	local city_loc = self:GetCityOrigin(region, city)
	local angle = self:GetCityFacing(region, city)
	local race = self:GetCityRace(region, city)
	local player = self:GetCityOwner(region, city)
	local city_name = "npc_kingdom_"..race.."_city"
	local player_id = Kingdom:GetPlayerID(player)
	local facing_position = RotatePosition(Vector(city_loc.x, city_loc.y, 0), QAngle(0, angle, 0), Vector(city_loc.x, city_loc.y, 0) + Vector(100, 0, 0))

	-- Spawn city
	local unit = CreateUnitByName(city_name, Vector(city_loc.x, city_loc.y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	unit:FaceTowards(facing_position)
	unit:AddNewModifier(unit, nil, "modifier_kingdom_city", {})

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

-- Requires n regions with n cities each, to be distributed amongst n players
function MapManager:PerformInitialCityDistribution()
	local player_count = Kingdom:GetPlayerCount()
	local city_count = {}
	for player = 1, player_count do
		city_count[player] = {}
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