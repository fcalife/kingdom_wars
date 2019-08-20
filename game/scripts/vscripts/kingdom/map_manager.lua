-- Map manager initialization
if MapManager == nil then
	_G.MapManager = class({})
end

function MapManager:Init()
	print("--- Map manager: initializing")

	-- Load map information
	self.map_info = LoadKeyValues("scripts/npc/KV/map.kv")

	-- Set up geography constants
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

	-- Generate city owner information
	self.city_owners = {}
	for region = 1, self:GetRegionCount() do
		self.city_owners[region] = {}
		for city = 1, self:GetRegionCityCount(region) do
			self.city_owners[region][city] = 0
		end
	end

	-- Distribute cities amongst players randomly
	print("- Map manager: distributing cities amongst players")
	self:PerformInitialCityDistribution()
	PrintTable(self.city_owners)

	-- Spawn towers and cities for each player
	print("- Map manager: spawning cities and towers")
	--for region = 1, self:GetRegionCount() do
	for region = 1, 1 do
		for city = 1, self:GetRegionCityCount(region) do
			local city_loc = self:GetCityOrigin(region, city)
			local city_angle = self:GetCityFacing(region, city)
			local city_race = self:GetCityRace(region, city)
			local tower_loc = self:GetCityTowerSpawnPoint(region, city)
			local player = self:GetCityOwner(region, city)
			self:SpawnTower(tower_loc.x, tower_loc.y, city_race, player)
			self:SpawnCity(city_loc.x, city_loc.y, city_angle, city_race, player)
		end
	end

	print("Map manager: finished initializing")
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
	return Vector(self.map_info[tostring(region)][tostring(city)]["capture_zone"]["x"], self.map_info[tostring(region)][tostring(city)]["capture_zone"]["y"], 0)
end

function MapManager:GetCityCaptureZoneRadius(region, city)
	return self.map_info[tostring(region)][tostring(city)]["capture_zone"]["radius"]
end



-- City ownership
function MapManager:GetCityOwner(region, city)
	return self.city_owners[region][city]
end

function MapManager:SetCityOwner(region, city, player)
	self.city_owners[region][city] = player
end



-- Spawners
function MapManager:SpawnTower(x, y, race, player)
	local tower_name = "npc_kingdom_tower_"..race
	local player_id = Kingdom:GetPlayerID(player)
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	local tower = CreateUnitByName(tower_name, Vector(x, y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	ResolveNPCPositions(Vector(x, y, 0), 128)
	tower:FaceTowards(tower:GetAbsOrigin() + Vector(0, -100, 0))
	tower:SetControllableByPlayer(player_id, true)
	tower:SetRenderColor(player_color.x, player_color.y, player_color.z)

	-- Race-specific stuff
	if race == "orc" then
		tower:SetRenderColor(74, 59, 65)
	end
end

function MapManager:SpawnCity(x, y, angle, race, player)
	local city_name = "npc_kingdom_"..race.."_city"
	local player_id = Kingdom:GetPlayerID(player)
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	local facing_position = RotatePosition(Vector(x, y, 0), QAngle(0, angle, 0), Vector(x, y, 0) + Vector(100, 0, 0))
	local city = CreateUnitByName(city_name, Vector(x, y, 0), false, nil, nil, PlayerResource:GetTeam(player_id))
	city:FaceTowards(facing_position)
	city:SetControllableByPlayer(player_id, true)

	-- Race-specific stuff
	if race == "orc" then
		city:SetRenderColor(74, 59, 65)
	elseif race == "undead" then
		city:AddNewModifier(city, nil, "modifier_kingdom_undead_city_animation", {})
	elseif race == "keen" then
		city:AddNewModifier(city, nil, "modifier_kingdom_keen_city_animation", {})
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