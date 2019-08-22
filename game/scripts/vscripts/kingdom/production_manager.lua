-- Production manager initialization
if ProductionManager == nil then
	_G.ProductionManager = class({})
end

-- Unit spawners
function ProductionManager:SpawnUnit(region, city, unit_type)
	local player = MapManager:GetCityOwner(region, city)
	local player_id = Kingdom:GetPlayerID(player)
	local player_color = Kingdom:GetKingdomPlayerColor(player)
	local city_race = MapManager:GetCityRace(region, city)
	local spawn_loc = MapManager:GetCityMeleeSpawnPoint(region, city)
	if unit_type == "ranged" then
		spawn_loc = MapManager:GetCityRangedSpawnPoint(region, city)
	end
	local unit = CreateUnitByName("npc_kingdom_"..city_race.."_"..unit_type, spawn_loc, true, nil, nil, PlayerResource:GetTeam(player_id))
	unit:SetControllableByPlayer(player_id, true)
	--unit:SetRenderColor(player_color.x, player_color.y, player_color.z)
	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(unit:GetAbsOrigin(), 128)
	end)
end