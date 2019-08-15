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

	-- Spawn towers for each city
	print("- Map manager: spawning city towers")
	for region = 1, self:GetRegionCount() do
		for city = 1, self:GetRegionCityCount(region) do
			--self:GetCityTowerSpawnPoint(region, city)
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

function MapManager:GetCityTowerSpawnPoint(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["tower"]["x"], self.map_info[tostring(region)][tostring(city)]["tower"]["y"], 0)
end

function MapManager:GetCityMeleeSpawnPoint(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["melee_spawn"]["x"], self.map_info[tostring(region)][tostring(city)]["melee_spawn"]["y"], 0)
end

function MapManager:GetCityRangedSpawnPoint(region, city)
	return Vector(self.map_info[tostring(region)][tostring(city)]["ranged_spawn"]["x"], self.map_info[tostring(region)][tostring(city)]["ranged_spawn"]["y"], 0)
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
			print("giving city "..city.." of region "..region.." to player "..random_player)
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
			print("swaps remaining: "..swap_count)
			for city, owner in pairs(self.city_owners[region_1]) do
				if owner == player_1 then
					print("swapped city "..city.." from region "..region_1.." from player "..player_1.." to player "..player_2)
					self:SetCityOwner(region_1, city, player_2)
					break
				end
			end
			for city, owner in pairs(self.city_owners[region_2]) do
				if owner == player_2 then
					print("swapped city "..city.." from region "..region_2.." from player "..player_2.." to player "..player_1)
					self:SetCityOwner(region_2, city, player_1)
					break
				end
			end
		else
			print("swap failed! trying again")
			sequential_fails = sequential_fails + 1
		end

		if sequential_fails >= 10 then
			print("too many swap failures, stopping")
			swap_count = 0
		end
	end
	PrintTable(city_count)
end