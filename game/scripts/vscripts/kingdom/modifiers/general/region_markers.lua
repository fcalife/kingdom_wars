--	Regional bonus markers

LinkLuaModifier("modifier_kingdom_r1_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r1_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r2_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r2_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r3_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r3_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r4_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r4_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r5_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r5_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r6_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r6_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r7_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r7_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r8_owner_half", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r8_owner_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_kingdom_region_attack_bonus_melee", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_attack_bonus_ranged", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_attack_bonus_cavalry", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_health_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_health_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_ms_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_ms_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_as_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_as_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_armor_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_armor_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)



modifier_kingdom_region_attack_bonus_melee = class({})

function modifier_kingdom_region_attack_bonus_melee:IsHidden() return false end
function modifier_kingdom_region_attack_bonus_melee:IsDebuff() return false end
function modifier_kingdom_region_attack_bonus_melee:IsPurgable() return false end
function modifier_kingdom_region_attack_bonus_melee:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_attack_bonus_melee:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())

		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.2 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.2 * damage)
	end
end

function modifier_kingdom_region_attack_bonus_melee:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE }
end

function modifier_kingdom_region_attack_bonus_melee:GetModifierModelScale()
	return 6
end


modifier_kingdom_region_attack_bonus_ranged = class({})

function modifier_kingdom_region_attack_bonus_ranged:IsHidden() return false end
function modifier_kingdom_region_attack_bonus_ranged:IsDebuff() return false end
function modifier_kingdom_region_attack_bonus_ranged:IsPurgable() return false end
function modifier_kingdom_region_attack_bonus_ranged:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_attack_bonus_ranged:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())

		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.2 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.2 * damage)
	end
end

function modifier_kingdom_region_attack_bonus_ranged:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE }
end

function modifier_kingdom_region_attack_bonus_ranged:GetModifierModelScale()
	return 6
end



modifier_kingdom_region_attack_bonus_cavalry = class({})

function modifier_kingdom_region_attack_bonus_cavalry:IsHidden() return false end
function modifier_kingdom_region_attack_bonus_cavalry:IsDebuff() return false end
function modifier_kingdom_region_attack_bonus_cavalry:IsPurgable() return false end
function modifier_kingdom_region_attack_bonus_cavalry:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_attack_bonus_cavalry:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())

		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.2 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.2 * damage)
	end
end

function modifier_kingdom_region_attack_bonus_cavalry:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE }
end

function modifier_kingdom_region_attack_bonus_cavalry:GetModifierModelScale()
	return 6
end



modifier_kingdom_region_health_bonus = class({})

function modifier_kingdom_region_health_bonus:IsHidden() return false end
function modifier_kingdom_region_health_bonus:IsDebuff() return false end
function modifier_kingdom_region_health_bonus:IsPurgable() return false end
function modifier_kingdom_region_health_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_health_bonus:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()

		parent:SetBaseMaxHealth(base_health * 1.1)
		parent:SetMaxHealth(base_health * 1.1)
		parent:SetHealth(base_health * 1.1)
	end
end

function modifier_kingdom_region_health_bonus:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE }
end

function modifier_kingdom_region_health_bonus:GetModifierModelScale()
	return 3
end



modifier_kingdom_region_health_bonus_full = class({})

function modifier_kingdom_region_health_bonus_full:IsHidden() return false end
function modifier_kingdom_region_health_bonus_full:IsDebuff() return false end
function modifier_kingdom_region_health_bonus_full:IsPurgable() return false end
function modifier_kingdom_region_health_bonus_full:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_health_bonus_full:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()

		parent:SetBaseMaxHealth(base_health * 1.2)
		parent:SetMaxHealth(base_health * 1.2)
		parent:SetHealth(base_health * 1.2)
	end
end

function modifier_kingdom_region_health_bonus_full:DeclareFunctions()
	return { MODIFIER_PROPERTY_MODEL_SCALE }
end

function modifier_kingdom_region_health_bonus_full:GetModifierModelScale()
	return 6
end



modifier_kingdom_region_ms_bonus = class({})

function modifier_kingdom_region_ms_bonus:IsHidden() return false end
function modifier_kingdom_region_ms_bonus:IsDebuff() return false end
function modifier_kingdom_region_ms_bonus:IsPurgable() return false end
function modifier_kingdom_region_ms_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_ms_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_kingdom_region_ms_bonus:GetModifierMoveSpeedBonus_Percentage()
	return 10
end

function modifier_kingdom_region_ms_bonus:GetModifierModelScale()
	return 3
end



modifier_kingdom_region_ms_bonus_full = class({})

function modifier_kingdom_region_ms_bonus_full:IsHidden() return false end
function modifier_kingdom_region_ms_bonus_full:IsDebuff() return false end
function modifier_kingdom_region_ms_bonus_full:IsPurgable() return false end
function modifier_kingdom_region_ms_bonus_full:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_ms_bonus_full:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_kingdom_region_ms_bonus_full:GetModifierMoveSpeedBonus_Percentage()
	return 20
end

function modifier_kingdom_region_ms_bonus_full:GetModifierModelScale()
	return 6
end




modifier_kingdom_region_as_bonus = class({})

function modifier_kingdom_region_as_bonus:IsHidden() return false end
function modifier_kingdom_region_as_bonus:IsDebuff() return false end
function modifier_kingdom_region_as_bonus:IsPurgable() return false end
function modifier_kingdom_region_as_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_as_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_kingdom_region_as_bonus:GetModifierAttackSpeedBonus_Constant()
	return 10
end

function modifier_kingdom_region_as_bonus:GetModifierModelScale()
	return 3
end



modifier_kingdom_region_as_bonus_full = class({})

function modifier_kingdom_region_as_bonus_full:IsHidden() return false end
function modifier_kingdom_region_as_bonus_full:IsDebuff() return false end
function modifier_kingdom_region_as_bonus_full:IsPurgable() return false end
function modifier_kingdom_region_as_bonus_full:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_as_bonus_full:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_kingdom_region_as_bonus_full:GetModifierAttackSpeedBonus_Constant()
	return 20
end

function modifier_kingdom_region_as_bonus_full:GetModifierModelScale()
	return 6
end



modifier_kingdom_region_armor_bonus = class({})

function modifier_kingdom_region_armor_bonus:IsHidden() return false end
function modifier_kingdom_region_armor_bonus:IsDebuff() return false end
function modifier_kingdom_region_armor_bonus:IsPurgable() return false end
function modifier_kingdom_region_armor_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_armor_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_kingdom_region_armor_bonus:GetModifierPhysicalArmorBonus()
	return 2
end

function modifier_kingdom_region_armor_bonus:GetModifierModelScale()
	return 3
end



modifier_kingdom_region_armor_bonus_full = class({})

function modifier_kingdom_region_armor_bonus_full:IsHidden() return false end
function modifier_kingdom_region_armor_bonus_full:IsDebuff() return false end
function modifier_kingdom_region_armor_bonus_full:IsPurgable() return false end
function modifier_kingdom_region_armor_bonus_full:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_armor_bonus_full:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_kingdom_region_armor_bonus_full:GetModifierPhysicalArmorBonus()
	return 4
end

function modifier_kingdom_region_armor_bonus_full:GetModifierModelScale()
	return 6
end



modifier_kingdom_r1_owner_half = class({})

function modifier_kingdom_r1_owner_half:IsDebuff() return false end
function modifier_kingdom_r1_owner_half:IsHidden() return true end
function modifier_kingdom_r1_owner_half:IsPurgable() return false end
function modifier_kingdom_r1_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r1_owner_full = class({})

function modifier_kingdom_r1_owner_full:IsDebuff() return false end
function modifier_kingdom_r1_owner_full:IsHidden() return true end
function modifier_kingdom_r1_owner_full:IsPurgable() return false end
function modifier_kingdom_r1_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r2_owner_half = class({})

function modifier_kingdom_r2_owner_half:IsDebuff() return false end
function modifier_kingdom_r2_owner_half:IsHidden() return true end
function modifier_kingdom_r2_owner_half:IsPurgable() return false end
function modifier_kingdom_r2_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r2_owner_full = class({})

function modifier_kingdom_r2_owner_full:IsDebuff() return false end
function modifier_kingdom_r2_owner_full:IsHidden() return true end
function modifier_kingdom_r2_owner_full:IsPurgable() return false end
function modifier_kingdom_r2_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r3_owner_half = class({})

function modifier_kingdom_r3_owner_half:IsDebuff() return false end
function modifier_kingdom_r3_owner_half:IsHidden() return true end
function modifier_kingdom_r3_owner_half:IsPurgable() return false end
function modifier_kingdom_r3_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r3_owner_full = class({})

function modifier_kingdom_r3_owner_full:IsDebuff() return false end
function modifier_kingdom_r3_owner_full:IsHidden() return true end
function modifier_kingdom_r3_owner_full:IsPurgable() return false end
function modifier_kingdom_r3_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r4_owner_half = class({})

function modifier_kingdom_r4_owner_half:IsDebuff() return false end
function modifier_kingdom_r4_owner_half:IsHidden() return true end
function modifier_kingdom_r4_owner_half:IsPurgable() return false end
function modifier_kingdom_r4_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r4_owner_full = class({})

function modifier_kingdom_r4_owner_full:IsDebuff() return false end
function modifier_kingdom_r4_owner_full:IsHidden() return true end
function modifier_kingdom_r4_owner_full:IsPurgable() return false end
function modifier_kingdom_r4_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r5_owner_half = class({})

function modifier_kingdom_r5_owner_half:IsDebuff() return false end
function modifier_kingdom_r5_owner_half:IsHidden() return true end
function modifier_kingdom_r5_owner_half:IsPurgable() return false end
function modifier_kingdom_r5_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r5_owner_full = class({})

function modifier_kingdom_r5_owner_full:IsDebuff() return false end
function modifier_kingdom_r5_owner_full:IsHidden() return true end
function modifier_kingdom_r5_owner_full:IsPurgable() return false end
function modifier_kingdom_r5_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r6_owner_half = class({})

function modifier_kingdom_r6_owner_half:IsDebuff() return false end
function modifier_kingdom_r6_owner_half:IsHidden() return true end
function modifier_kingdom_r6_owner_half:IsPurgable() return false end
function modifier_kingdom_r6_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r6_owner_full = class({})

function modifier_kingdom_r6_owner_full:IsDebuff() return false end
function modifier_kingdom_r6_owner_full:IsHidden() return true end
function modifier_kingdom_r6_owner_full:IsPurgable() return false end
function modifier_kingdom_r6_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r7_owner_half = class({})

function modifier_kingdom_r7_owner_half:IsDebuff() return false end
function modifier_kingdom_r7_owner_half:IsHidden() return true end
function modifier_kingdom_r7_owner_half:IsPurgable() return false end
function modifier_kingdom_r7_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r7_owner_full = class({})

function modifier_kingdom_r7_owner_full:IsDebuff() return false end
function modifier_kingdom_r7_owner_full:IsHidden() return true end
function modifier_kingdom_r7_owner_full:IsPurgable() return false end
function modifier_kingdom_r7_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r8_owner_half = class({})

function modifier_kingdom_r8_owner_half:IsDebuff() return false end
function modifier_kingdom_r8_owner_half:IsHidden() return true end
function modifier_kingdom_r8_owner_half:IsPurgable() return false end
function modifier_kingdom_r8_owner_half:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

modifier_kingdom_r8_owner_full = class({})

function modifier_kingdom_r8_owner_full:IsDebuff() return false end
function modifier_kingdom_r8_owner_full:IsHidden() return true end
function modifier_kingdom_r8_owner_full:IsPurgable() return false end
function modifier_kingdom_r8_owner_full:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end