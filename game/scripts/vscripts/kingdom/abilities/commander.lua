-- Commander abilities

kingdom_global_rally_point = class({})

function kingdom_global_rally_point:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local player = Kingdom:GetPlayerByTeam(caster:GetTeam())
		local cast_loc = self:GetCursorPosition()
		local target_loc = Vector(cast_loc.x, cast_loc.y, cast_loc.z)

		EmitSoundOnLocationWithCaster(target_loc, "General.PingAttack", caster)

		local ping_pfx = ParticleManager:CreateParticleForTeam("particles/ui_mouseactions/ping_waypoint.vpcf", PATTACH_CUSTOMORIGIN, nil, caster:GetTeam())
		ParticleManager:SetParticleControl(ping_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(ping_pfx, 5, Vector(3, 0, 0))
		ParticleManager:SetParticleControl(ping_pfx, 7, Vector(255, 0, 0))
		ParticleManager:ReleaseParticleIndex(ping_pfx)

		for region = 1, MapManager:GetRegionCount() do
			for city = 1, MapManager:GetRegionCityCount(region) do
				if MapManager:GetCityOwner(region, city) == player then
					local city_unit = MapManager:GetCityByNumber(region, city)
					MapManager:SetRallyPoint(city_unit.region, city_unit.city, target_loc)
				end
			end
		end
	end
end





kingdom_select_all_units = class({})

function kingdom_select_all_units:OnSpellStart()
	if IsServer() then
		CustomGameEventManager:Send_ServerToTeam(self:GetCaster():GetTeam(), "kingdom_select_all_units", {})
	end
end





kingdom_ping_all_castles = class({})

function kingdom_ping_all_castles:OnSpellStart()
	if IsServer() then
		local team = self:GetCaster():GetTeam()
		local player = Kingdom:GetPlayerByTeam(team)

		for region = 1, MapManager:GetRegionCount() do
			for city = 1, MapManager:GetRegionCityCount(region) do
				if MapManager:GetCityOwner(region, city) == player then
					local target_loc = MapManager:GetCityByNumber(region, city):GetAbsOrigin()
					CustomGameEventManager:Send_ServerToTeam(team, "kingdom_minimap_ping", {x = target_loc.x, y = target_loc.y, z = target_loc.z + 10})
				end
			end
		end
	end
end