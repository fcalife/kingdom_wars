--	Regional bonuses

LinkLuaModifier("modifier_kingdom_r1_contender", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r2_contender", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r5_contender", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r5_owner", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_r6_contender", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_kingdom_region_attack_bonus_melee", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_attack_bonus_ranged", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_attack_bonus_cavalry", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_health_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_health_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_as_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_as_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_armor_bonus", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingdom_region_armor_bonus_full", "kingdom/modifiers/general/region_markers", LUA_MODIFIER_MOTION_NONE)





modifier_kingdom_r1_contender = class({})

function modifier_kingdom_r1_contender:IsHidden() return true end
function modifier_kingdom_r1_contender:IsDebuff() return false end
function modifier_kingdom_r1_contender:IsPurgable() return false end
function modifier_kingdom_r1_contender:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_kingdom_r2_contender = class({})

function modifier_kingdom_r2_contender:IsHidden() return true end
function modifier_kingdom_r2_contender:IsDebuff() return false end
function modifier_kingdom_r2_contender:IsPurgable() return false end
function modifier_kingdom_r2_contender:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_kingdom_r5_contender = class({})

function modifier_kingdom_r5_contender:IsHidden() return true end
function modifier_kingdom_r5_contender:IsDebuff() return false end
function modifier_kingdom_r5_contender:IsPurgable() return false end
function modifier_kingdom_r5_contender:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_kingdom_r5_owner = class({})

function modifier_kingdom_r5_owner:IsHidden() return true end
function modifier_kingdom_r5_owner:IsDebuff() return false end
function modifier_kingdom_r5_owner:IsPurgable() return false end
function modifier_kingdom_r5_owner:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

modifier_kingdom_r6_contender = class({})

function modifier_kingdom_r6_contender:IsHidden() return true end
function modifier_kingdom_r6_contender:IsDebuff() return false end
function modifier_kingdom_r6_contender:IsPurgable() return false end
function modifier_kingdom_r6_contender:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end





modifier_kingdom_region_attack_bonus_melee = class({})

function modifier_kingdom_region_attack_bonus_melee:IsHidden() return false end
function modifier_kingdom_region_attack_bonus_melee:IsDebuff() return false end
function modifier_kingdom_region_attack_bonus_melee:IsPurgable() return false end
function modifier_kingdom_region_attack_bonus_melee:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_attack_bonus_melee:GetTexture()
	return "custom/region_1"
end

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

function modifier_kingdom_region_attack_bonus_ranged:GetTexture()
	return "custom/region_6"
end

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

function modifier_kingdom_region_attack_bonus_cavalry:GetTexture()
	return "custom/region_2"
end

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

function modifier_kingdom_region_health_bonus:GetTexture()
	return "custom/region_3"
end

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

function modifier_kingdom_region_health_bonus_full:GetTexture()
	return "custom/region_3"
end

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



modifier_kingdom_region_as_bonus = class({})

function modifier_kingdom_region_as_bonus:IsHidden() return false end
function modifier_kingdom_region_as_bonus:IsDebuff() return false end
function modifier_kingdom_region_as_bonus:IsPurgable() return false end
function modifier_kingdom_region_as_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_region_as_bonus:GetTexture()
	return "custom/region_7"
end

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

function modifier_kingdom_region_as_bonus_full:GetTexture()
	return "custom/region_7"
end

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

function modifier_kingdom_region_armor_bonus:GetTexture()
	return "custom/region_8"
end

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

function modifier_kingdom_region_armor_bonus_full:GetTexture()
	return "custom/region_8"
end

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