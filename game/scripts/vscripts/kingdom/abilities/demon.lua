--	Demonic unit abilities

kingdom_buy_demon_melee = class({})

function kingdom_buy_demon_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_demon_melee:GetGoldCost(level)
	return 5
end



kingdom_buy_demon_ranged = class({})

function kingdom_buy_demon_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_demon_ranged:GetGoldCost(level)
	return 7
end



kingdom_buy_demon_cavalry = class({})

function kingdom_buy_demon_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_demon_cavalry:GetGoldCost(level)
	return 9
end



kingdom_demon_melee_ability = class({})

function kingdom_demon_melee_ability:GetIntrinsicModifierName()
	return "modifier_demon_melee_ability"
end

LinkLuaModifier("modifier_demon_melee_ability", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_melee_ability_effect", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)

modifier_demon_melee_ability = class({})

function modifier_demon_melee_ability:IsHidden() return true end
function modifier_demon_melee_ability:IsDebuff() return false end
function modifier_demon_melee_ability:IsPurgable() return false end
function modifier_demon_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_demon_melee_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_demon_melee_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local modifier = parent:AddNewModifier(parent, ability, "modifier_demon_melee_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
			if modifier:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
				modifier:IncrementStackCount()
			end
		end
	end
end

modifier_demon_melee_ability_effect = class({})

function modifier_demon_melee_ability_effect:IsHidden() return false end
function modifier_demon_melee_ability_effect:IsDebuff() return false end
function modifier_demon_melee_ability_effect:IsPurgable() return false end
function modifier_demon_melee_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_demon_melee_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_demon_melee_ability_effect:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_ms") * self:GetStackCount()
end

function modifier_demon_melee_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") * self:GetStackCount()
end