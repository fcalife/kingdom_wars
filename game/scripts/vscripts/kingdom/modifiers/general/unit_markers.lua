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