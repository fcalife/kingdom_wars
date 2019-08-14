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

function MapManager:PerformInitialCityDistribution()
	local player_count = Kingdom:GetPlayerCount()
	local max_total_cities = math.ceil(self:GetCityCount() / player_count)
	local remaining_players = {}
	local total_city_count = {}
	for player = 1, player_count do
		table.insert(remaining_players, player)
		total_city_count[player] = 0
	end
	print("max total cities per player: "..max_total_cities)
	print("total cities to distribute: "..self:GetCityCount())

	for region = 1, self:GetRegionCount() do
		local max_region_cities = math.ceil(self:GetRegionCityCount(region) / player_count) + 1
		local remaining_region_players = {}
		local region_city_count = {}
		for _, player in pairs(remaining_players) do
			table.insert(remaining_region_players, player)
			region_city_count[player] = 0
		end

		print("distributing cities on region "..region)
		print("max cities per player in this region: "..max_region_cities)
		print("player city count:")
		PrintTable(total_city_count)
		print("players still receiving cities:")
		PrintTable(remaining_players)

		for city, owner in pairs(self.city_owners[region]) do
			local random_player = remaining_region_players[RandomInt(1, #remaining_region_players)]
			self:SetCityOwner(region, city, random_player)
			total_city_count[random_player] = total_city_count[random_player] + 1
			region_city_count[random_player] = region_city_count[random_player] + 1
			if total_city_count[random_player] >= max_total_cities then
				table.remove(remaining_players, random_player)
				table.remove(remaining_region_players, random_player)
			elseif region_city_count[random_player] >= max_region_cities then
				table.remove(remaining_region_players, random_player)
			end
			print("giving city "..city.." to player "..random_player)
			print("players still receiving cities:")
			PrintTable(remaining_players)
			print("players still receiving cities on this region:")
			PrintTable(remaining_region_players)
			print("player city count on this region:")
			PrintTable(region_city_count)
		end
	end
end