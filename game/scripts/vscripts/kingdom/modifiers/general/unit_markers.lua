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
			ability:StartCooldown(30.0)
		end
	end
end