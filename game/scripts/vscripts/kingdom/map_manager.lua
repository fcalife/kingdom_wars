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
	self.region_owners = {}
	self.city_owners = {}
	self.cities = {}
	self.towers = {}
	self.tower_bases = {}
	self.capture_info = {}
	self.demon_portals = {}
	self.rally_points = {}
	self.regional_spawners = {}
	for region = 1, self:GetRegionCount() do
		self.region_owners[region] = 0
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

	-- Same, but for demon portals
	for portal = 1, self:GetDemonPortalCount() do
		self:StartPortalCaptureTracking(portal)
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

function MapManager:GetDemonPortalCount()
	return self.demon_portal_count
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

function MapManager:GetBeastSpawnPoint(region)
	return Vector(self.neutrals_map_info["beast_spawns"][tostring(region)]["x"], self.neutrals_map_info["beast_spawns"][tostring(region)]["y"], 0)
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

	-- Count portals
	for portal = 1, self:GetDemonPortalCount() do
		if self.demon_portals[portal]["owner_player"] > 0 then
			self.player_city_count[self.demon_portals[portal]["owner_player"]] = self.player_city_count[self.demon_portals[portal]["owner_player"]] + 1
		end
	end

	for player = 1, Kingdom:GetPlayerCount() do
		local player_id = Kingdom:GetPlayerID(player)
		CustomNetTables:SetTableValue("player_info", "player_cities_"..player_id, {city_amount = self.player_city_count[player]})

		if self.player_city_count[player] >= 48 then
			GameRules:SetGameWinner(Kingdom:GetKingdomPlayerTeam(player))
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
		local start_point = self:GetCityCaptureZoneCenter(region, city) + Vector(0, -144, 0)
		local end_point = start_point + Vector(0, 288, 0)
		local allies = FindUnitsInLine(city_team, start_point, end_point, nil, 288, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
		local enemies = FindUnitsInLine(city_team, start_point, end_point, nil, 288, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		local attacking_player = 0
		local engineer_present = false
		local bounty_hunter_present = nil

		if #enemies > 0 then
			attacking_player = Kingdom:GetPlayerByTeam(enemies[1]:GetTeam())
		end

		for _, enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_keen_engineer_ability") and enemy:IsAlive() then
				engineer_present = true
			end
			if enemy:HasModifier("modifier_keen_bounty_hunter_ability") and enemy:IsAlive() then
				bounty_hunter_present = enemy
			end
		end

		if attacking_player then
			self:ProcessCapture(region, city, #allies, #enemies, attacking_player, owner_player, engineer_present, bounty_hunter_present)
		end
		return 0.5
	end)
end

function MapManager:ProcessCapture(region, city, ally_count, enemy_count, attacking_player, owner_player, engineer_present, bounty_hunter_present)

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

		-- Engineer ability
		if engineer_present then
			self.capture_info[region][city].progress = self.capture_info[region][city].progress + 0.75 / self.city_capture_time[city_level]
		else
			self.capture_info[region][city].progress = self.capture_info[region][city].progress + 0.5 / self.city_capture_time[city_level]
		end

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

			if not engineer_present then
				self:RazeCity(region, city)
			end

			if bounty_hunter_present then
				PlayerResource:ModifyGold(Kingdom:GetPlayerID(attacking_player), 10, true, DOTA_ModifyGold_HeroKill)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD , bounty_hunter_present, 10, nil)
			end

			self:CaptureCity(region, city, attacking_player)
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
		local start_point = self.demon_portals[portal]["capture_point"] + Vector(0, -144, 0)
		local end_point = start_point + Vector(0, 288, 0)

		local allies = FindUnitsInLine(city_team, start_point, end_point, nil, 288, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
		local enemies = FindUnitsInLine(city_team, start_point, end_point, nil, 288, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
		local attacking_player = 0
		local engineer_present = false
		local bounty_hunter_present = nil

		if #enemies > 0 then
			attacking_player = Kingdom:GetPlayerByTeam(enemies[1]:GetTeam())
		end

		for _, enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_keen_engineer_ability") and enemy:IsAlive() then
				engineer_present = true
			end
			if enemy:HasModifier("modifier_keen_bounty_hunter_ability") and enemy:IsAlive() then
				bounty_hunter_present = enemy
			end
		end

		if attacking_player then
			self:ProcessPortalCapture(portal, #allies, #enemies, attacking_player, owner_player, engineer_present, bounty_hunter_present)
		end
		return 0.5
	end)
end

function MapManager:ProcessPortalCapture(portal, ally_count, enemy_count, attacking_player, owner_player, engineer_present, bounty_hunter_present)

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

		-- Engineer ability
		if engineer_present then
			self.demon_portals[portal]["capture_info"].progress = self.demon_portals[portal]["capture_info"].progress + 0.75 / self.city_capture_time[portal_level]
		else
			self.demon_portals[portal]["capture_info"].progress = self.demon_portals[portal]["capture_info"].progress + 0.5 / self.city_capture_time[portal_level]
		end

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

			if not engineer_present then
				self:RazePortal(portal)
			end

			if bounty_hunter_present then
				PlayerResource:ModifyGold(Kingdom:GetPlayerID(attacking_player), 10, true, DOTA_ModifyGold_HeroKill)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD , bounty_hunter_present, 10, nil)
			end

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
	self:SetCityOwner(region, city, player)
	self:SetCityControllable(region, city, player)
	self:GetCityByNumber(region, city):SetTeam(team)
	self:GetTowerByNumber(region, city):SetTeam(team)
	self:ClearRallyPoint(region, city)

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
	city_unit:CreatureLevelUp(1 - city_unit:GetLevel())
	tower_unit:CreatureLevelUp(1 - city_unit:GetLevel())

	if city_unit.upgrade_pfx then
		ParticleManager:DestroyParticle(city_unit.upgrade_pfx, false)
		ParticleManager:ReleaseParticleIndex(city_unit.upgrade_pfx)
	end
end

function MapManager:RazePortal(portal)
	local city_unit = self.demon_portals[portal]["portal"]
	city_unit:CreatureLevelUp(1 - city_unit:GetLevel())

	if city_unit.upgrade_pfx then
		ParticleManager:DestroyParticle(city_unit.upgrade_pfx, false)
		ParticleManager:ReleaseParticleIndex(city_unit.upgrade_pfx)
	end
end

function MapManager:UpgradeCity(region, city)
	local city_unit = self:GetCityByNumber(region, city)
	local tower_unit = self:GetTowerByNumber(region, city)
	city_unit:CreatureLevelUp(1)
	tower_unit:CreatureLevelUp(1)

	if city_unit.upgrade_pfx then
		ParticleManager:SetParticleControl(city_unit.upgrade_pfx, 1, Vector(400, 0, 0))
	else
		city_unit.upgrade_pfx = ParticleManager:CreateParticle("particles/items_fx/gem_truesight_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(city_unit.upgrade_pfx, 0, city_unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(city_unit.upgrade_pfx, 1, Vector(300, 0, 0))
	end
end

function MapManager:UpgradePortal(portal)
	local portal_unit = self.demon_portals[portal]["portal"]
	portal_unit:CreatureLevelUp(1)

	if portal_unit.upgrade_pfx then
		ParticleManager:SetParticleControl(portal_unit.upgrade_pfx, 1, Vector(400, 0, 0))
	else
		portal_unit.upgrade_pfx = ParticleManager:CreateParticle("particles/items_fx/gem_truesight_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(portal_unit.upgrade_pfx, 0, portal_unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(portal_unit.upgrade_pfx, 1, Vector(300, 0, 0))
	end
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

	-- Add hero spawning ability, if applicable
	if hero then
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
		local spawner = CreateUnitByName("npc_kingdom_regional_spawner", GetGroundPosition(location, spawner), false, nil, nil, DOTA_TEAM_NEUTRALS)
		local base = CreateUnitByName("npc_kingdom_regional_spawner_base", GetGroundPosition(location, base), false, nil, nil, DOTA_TEAM_NEUTRALS)

		spawner:AddNewModifier(spawner, nil, "modifier_kingdom_tower_base", {})
		base:AddNewModifier(base, nil, "modifier_kingdom_tower_base", {})

		spawner:SetAbsOrigin(GetGroundPosition(spawner:GetAbsOrigin(), spawner))
		base:SetAbsOrigin(GetGroundPosition(base:GetAbsOrigin(), base))

		self.regional_spawners[region].spawner = spawner
		self.regional_spawners[region].base = base
	end
end

function MapManager:SpawnDemonPortals()
	local remaining_regions = {1, 2, 3}
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
	local portal_loc = Vector(portal_info["city"]["x"], portal_info["city"]["y"], portal_info["capture_zone"]["height"] - 432)
	local angle = portal_info["city"]["angle"]
	local facing_position = RotatePosition(Vector(portal_loc.x, portal_loc.y, 0), QAngle(0, angle, 0), Vector(portal_loc.x, portal_loc.y, 0) + Vector(100, 0, 0))

	-- Spawn portal
	local portal = CreateUnitByName("npc_kingdom_city_demon", Vector(portal_loc.x, portal_loc.y, 0), false, nil, nil, DOTA_TEAM_NEUTRALS)
	portal:FaceTowards(facing_position)
	portal:AddNewModifier(portal, nil, "modifier_kingdom_city", {})
	portal:SetRenderColor(74, 59, 65)

	-- Spawn demon army
	local army_loc = Vector(portal_info["capture_zone"]["x"], portal_info["capture_zone"]["y"], 0)
	self:SpawnDemonArmy(army_loc, commander_name)

	local units = {}
	units["portal"] = portal
	units["tower"] = tower
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
	end)

	local melee_positions = {}
	melee_positions[1] = Vector(-250, -150, 0)
	melee_positions[2] = Vector(-125, -150, 0)
	melee_positions[3] = Vector(0, -150, 0)
	melee_positions[4] = Vector(125, -150, 0)
	melee_positions[5] = Vector(250, -150, 0)

	for i = 1, 5 do
		local unit = CreateUnitByName("npc_kingdom_demon_melee", location + melee_positions[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit.type = KINGDOM_UNIT_TYPE_MELEE
	end

	local ranged_positions = {}
	ranged_positions[1] = Vector(-250, 0, 0)
	ranged_positions[2] = Vector(-125, 0, 0)
	ranged_positions[3] = Vector(125, 0, 0)
	ranged_positions[4] = Vector(250, 0, 0)

	for i = 1, 4 do
		local unit = CreateUnitByName("npc_kingdom_demon_ranged", location + ranged_positions[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit.type = KINGDOM_UNIT_TYPE_RANGED
	end

	local cavalry_positions = {}
	cavalry_positions[1] = Vector(-250, 150, 0)
	cavalry_positions[2] = Vector(0, 150, 0)
	cavalry_positions[3] = Vector(250, 150, 0)

	for i = 1, 3 do
		local unit = CreateUnitByName("npc_kingdom_demon_cavalry", location + cavalry_positions[i], true, nil, nil, DOTA_TEAM_NEUTRALS)
		unit.type = KINGDOM_UNIT_TYPE_CAVALRY
	end

	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(location, 500)
	end)
end