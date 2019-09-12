--	Human unit abilities

kingdom_buy_human_melee = class({})

function kingdom_buy_human_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_human_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_human_ranged = class({})

function kingdom_buy_human_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_human_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_human_cavalry = class({})

function kingdom_buy_human_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_human_cavalry:GetGoldCost(level)
	return 5
end



kingdom_human_melee_ability = class({})

function kingdom_human_melee_ability:GetIntrinsicModifierName()
	return "modifier_human_melee_ability"
end

LinkLuaModifier("modifier_human_melee_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_melee_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_melee_ability = class({})

function modifier_human_melee_ability:IsHidden() return true end
function modifier_human_melee_ability:IsDebuff() return false end
function modifier_human_melee_ability:IsPurgable() return false end
function modifier_human_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_melee_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_human_melee_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			if keys.attacker:IsRangedAttacker() then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_human_melee_ability_effect", {duration = 0.03})
			end
		end
	end
end

modifier_human_melee_ability_effect = class({})

function modifier_human_melee_ability_effect:IsHidden() return true end
function modifier_human_melee_ability_effect:IsDebuff() return false end
function modifier_human_melee_ability_effect:IsPurgable() return false end
function modifier_human_melee_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_melee_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_human_melee_ability_effect:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end



kingdom_human_ranged_ability = class({})

function kingdom_human_ranged_ability:GetIntrinsicModifierName()
	return "modifier_human_ranged_ability"
end

LinkLuaModifier("modifier_human_ranged_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_ranged_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_ranged_ability = class({})

function modifier_human_ranged_ability:IsHidden() return true end
function modifier_human_ranged_ability:IsDebuff() return false end
function modifier_human_ranged_ability:IsPurgable() return false end
function modifier_human_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function modifier_human_ranged_ability:OnAttackStart(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			if RollPercentage(ability:GetSpecialValueFor("proc_chance")) then
				parent:AddNewModifier(parent, ability, "modifier_human_ranged_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
			end
		end
	end
end

modifier_human_ranged_ability_effect = class({})

function modifier_human_ranged_ability_effect:IsHidden() return false end
function modifier_human_ranged_ability_effect:IsDebuff() return false end
function modifier_human_ranged_ability_effect:IsPurgable() return false end
function modifier_human_ranged_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_ranged_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_human_ranged_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end



kingdom_human_cavalry_ability = class({})

function kingdom_human_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_human_cavalry_ability"
end

LinkLuaModifier("modifier_human_cavalry_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_cavalry_ability = class({})

function modifier_human_cavalry_ability:IsHidden() return false end
function modifier_human_cavalry_ability:IsDebuff() return false end
function modifier_human_cavalry_ability:IsPurgable() return false end
function modifier_human_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_human_cavalry_ability:OnUnitMoved(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			if self:GetStackCount() < 100 then
				self:IncrementStackCount()
			end
		end
	end
end

function modifier_human_cavalry_ability:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_human_cavalry_ability:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount()
end

function modifier_human_cavalry_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			self:SetStackCount(0)
		end
	end
end



kingdom_magic_attack_ability = class({})

function kingdom_magic_attack_ability:GetIntrinsicModifierName()
	return "modifier_magic_attack_ability"
end

LinkLuaModifier("modifier_magic_attack_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_attack_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_magic_attack_ability = class({})

function modifier_magic_attack_ability:IsHidden() return true end
function modifier_magic_attack_ability:IsDebuff() return false end
function modifier_magic_attack_ability:IsPurgable() return false end
function modifier_magic_attack_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_magic_attack_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_magic_attack_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local ability = self:GetAbility()
			keys.attacker:AddNewModifier(keys.attacker, ability, "modifier_magic_attack_ability_effect", {duration = 0.01})
			keys.target:AddNewModifier(keys.attacker, ability, "modifier_magic_attack_ability_effect", {duration = 0.01})
			ApplyDamage({attacker = keys.attacker, victim = keys.target, ability = ability, damage = keys.original_damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS})
		end
	end
end

modifier_magic_attack_ability_effect = class({})

function modifier_magic_attack_ability_effect:IsHidden() return true end
function modifier_magic_attack_ability_effect:IsDebuff() return false end
function modifier_magic_attack_ability_effect:IsPurgable() return false end
function modifier_magic_attack_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_magic_attack_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
	return funcs
end

function modifier_magic_attack_ability_effect:GetAbsoluteNoDamagePhysical()
	return 1
end