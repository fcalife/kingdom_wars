--	Hero unit bonuses

modifier_kingdom_hero_marker = class({})

function modifier_kingdom_hero_marker:IsDebuff() return false end
function modifier_kingdom_hero_marker:IsHidden() return true end
function modifier_kingdom_hero_marker:IsPurgable() return false end
function modifier_kingdom_hero_marker:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_kingdom_hero_marker:OnCreated(keys)
	if IsServer() then
		self.origin_ability = keys.ability_name
		self.origin_region = keys.region
		self.origin_city = keys.city

		local ability = MapManager:GetCityByNumber(self.origin_region, self.origin_city):FindAbilityByName(self.origin_ability)
		if ability then
			ability:SetActivated(false)
		end
	end
end

function modifier_kingdom_hero_marker:OnDestroy()
	if IsServer() then
		local ability = MapManager:GetCityByNumber(self.origin_region, self.origin_city):FindAbilityByName(self.origin_ability)
		if ability then
			ability:SetActivated(true)
			ability:StartCooldown(120)

			local event = {}
			event.playerid = self:GetParent():GetPlayerOwnerID()
			event.playername = PlayerResource:GetPlayerName(event.playerid)
			event.steamid = PlayerResource:GetSteamID(event.playerid)
			event.unitname = self:GetParent():GetUnitName()
			event.heroname = Kingdom:GetDotaNameFromHeroName(event.unitname)

			CustomGameEventManager:Send_ServerToAllClients("kingdom_hero_killed", {event})
		end
	end
end



modifier_kingdom_demon_hero_marker = class({})

function modifier_kingdom_demon_hero_marker:IsDebuff() return false end
function modifier_kingdom_demon_hero_marker:IsHidden() return true end
function modifier_kingdom_demon_hero_marker:IsPurgable() return false end
function modifier_kingdom_demon_hero_marker:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_kingdom_demon_hero_marker:OnCreated(keys)
	if IsServer() then
		self.origin_ability = keys.ability_name

		self.abilities = {}
		for i = 1, MapManager:GetDemonPortalCount() do
			self.abilities[i] = MapManager.demon_portals[i]["portal"]:FindAbilityByName(self.origin_ability)
			if self.abilities[i] then
				self.abilities[i]:SetActivated(false)
			end
		end
	end
end

function modifier_kingdom_demon_hero_marker:OnDestroy()
	if IsServer() then
		for _, ability in pairs(self.abilities) do
			ability:SetActivated(true)
			ability:StartCooldown(120)
		end

		local event = {}
		event.playerid = self:GetParent():GetPlayerOwnerID()
		if event.playerid then
			event.playername = PlayerResource:GetPlayerName(event.playerid)
			event.steamid = PlayerResource:GetSteamID(event.playerid)
		end

		event.unitname = self:GetParent():GetUnitName()
		event.heroname = Kingdom:GetDotaNameFromHeroName(event.unitname)

		CustomGameEventManager:Send_ServerToAllClients("kingdom_hero_killed", {event})
	end
end



modifier_kingdom_beast_marker = class({})

function modifier_kingdom_beast_marker:IsDebuff() return false end
function modifier_kingdom_beast_marker:IsHidden() return true end
function modifier_kingdom_beast_marker:IsPurgable() return false end

function modifier_kingdom_beast_marker:OnCreated(keys)
	if IsServer() then
		self.region = keys.region
		EconomyManager.current_beasts[self.region] = EconomyManager.current_beasts[self.region] + 1
	end
end

function modifier_kingdom_beast_marker:OnDestroy()
	if IsServer() then
		EconomyManager.current_beasts[self.region] = EconomyManager.current_beasts[self.region] - 1
	end
end



modifier_kingdom_unit_movement = class({})

function modifier_kingdom_unit_movement:IsHidden() return true end
function modifier_kingdom_unit_movement:IsDebuff() return false end
function modifier_kingdom_unit_movement:IsPurgable() return false end

function modifier_kingdom_unit_movement:OnCreated(keys)
	if IsServer() then
		if keys.player then
			self.player = keys.player
			EconomyManager.player_current_units[self.player] = EconomyManager.player_current_units[self.player] + 1
			EconomyManager:UpdateIncomeForPlayer(self.player)
		end
	end
end

function modifier_kingdom_unit_movement:OnDestroy()
	if IsServer() then
		if self.player then
			if self:GetParent().type then
				EconomyManager.player_current_food_use[self.player] = math.max(0, EconomyManager.player_current_food_use[self.player] - 1)
				CustomNetTables:SetTableValue("player_info", "food_"..Kingdom:GetPlayerID(self.player), {food = EconomyManager.player_current_food_use[self.player]})
			end
			EconomyManager.player_current_units[self.player] = EconomyManager.player_current_units[self.player] - 1
			EconomyManager:UpdateIncomeForPlayer(self.player)
		end

		-- If any players were eliminated, send a notification
		local player = Kingdom:GetPlayerByTeam(self:GetParent():GetTeam())
		if MapManager:CheckIfPlayerEliminated(player) then
			local player_id = self:GetParent():GetPlayerOwnerID()

			local event = {}
			event.playerid = player_id
			event.playername = PlayerResource:GetPlayerName(player_id)
			event.steamid = PlayerResource:GetSteamID(player_id)
			event.position = MapManager.players_remaining
			CustomGameEventManager:Send_ServerToAllClients("kingdom_player_eliminated", {event})

			MapManager.player_eliminated[player] = true
			MapManager.players_remaining = MapManager.players_remaining - 1

			PlayerResource:GetSelectedHeroEntity(player_id):AddNoDraw()
		end
	end
end

function modifier_kingdom_unit_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_kingdom_unit_movement:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_kingdom_unit_movement:OnDeath(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and not keys.attacker:IsHero() then
			self:IncrementStackCount()
			if self:GetStackCount() >= 3 then
				if (not keys.attacker:HasModifier("modifier_elite_unit")) and (not keys.attacker:HasModifier("kingdom_capital_unit")) then
					keys.attacker:AddAbility("kingdom_elite_unit"):SetLevel(1)
					self:SetStackCount(0)
				elseif keys.attacker:HasModifier("modifier_elite_unit") and (not keys.attacker:HasModifier("kingdom_capital_unit")) then
					keys.attacker:AddAbility("kingdom_capital_unit"):SetLevel(1)
					keys.attacker:RemoveAbility("kingdom_elite_unit")
					keys.attacker:RemoveModifierByName("modifier_elite_unit")
					self:SetStackCount(0)
				end
			end
		end
	end
end



modifier_kingdom_demon_spawn_leash = modifier_kingdom_demon_spawn_leash or class({})

function modifier_kingdom_demon_spawn_leash:IsHidden() return true end
function modifier_kingdom_demon_spawn_leash:IsDebuff() return false end
function modifier_kingdom_demon_spawn_leash:IsPurgable() return false end
function modifier_kingdom_demon_spawn_leash:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_kingdom_demon_spawn_leash:OnCreated(keys)
	if IsServer() then
		self.spawn_point = self:GetParent():GetAbsOrigin()
		self.back_to_spawn = false
		self.leash_distance = 1500
		self:StartIntervalThink(2.0)
	end
end

function modifier_kingdom_demon_spawn_leash:OnIntervalThink()
	if IsServer() then
		local distance = GridNav:FindPathLength(self:GetParent():GetAbsOrigin(), self.spawn_point)

		if distance >= self.leash_distance then
			self.back_to_spawn = true
		else
			self.back_to_spawn = false
		end

		if self.back_to_spawn == true then
			self:GetParent():MoveToPosition(self.spawn_point)
		end
	end
end