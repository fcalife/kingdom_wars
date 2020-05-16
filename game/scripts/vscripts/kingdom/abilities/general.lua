--	Attack and armor type abilities

kingdom_magic_attack = class({})

function kingdom_magic_attack:GetIntrinsicModifierName()
	return "modifier_magic_attack"
end

LinkLuaModifier("modifier_magic_attack", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magic_attack_effect", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_magic_attack = class({})

function modifier_magic_attack:IsHidden() return true end
function modifier_magic_attack:IsDebuff() return false end
function modifier_magic_attack:IsPurgable() return false end
function modifier_magic_attack:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_magic_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_magic_attack:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local ability = self:GetAbility()
			keys.attacker:AddNewModifier(keys.attacker, ability, "modifier_magic_attack_effect", {duration = 0.01})
			keys.target:AddNewModifier(keys.attacker, ability, "modifier_magic_attack_effect", {duration = 0.01})
			ApplyDamage({attacker = keys.attacker, victim = keys.target, ability = ability, damage = keys.original_damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS})
		end
	end
end

modifier_magic_attack_effect = class({})

function modifier_magic_attack_effect:IsHidden() return true end
function modifier_magic_attack_effect:IsDebuff() return false end
function modifier_magic_attack_effect:IsPurgable() return false end
function modifier_magic_attack_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_magic_attack_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
	return funcs
end

function modifier_magic_attack_effect:GetAbsoluteNoDamagePhysical()
	return 1
end





kingdom_piercing_attack = class({})

function kingdom_piercing_attack:GetIntrinsicModifierName()
	return "modifier_piercing_attack"
end

LinkLuaModifier("modifier_piercing_attack", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_piercing_attack = class({})

function modifier_piercing_attack:IsHidden() return true end
function modifier_piercing_attack:IsDebuff() return false end
function modifier_piercing_attack:IsPurgable() return false end
function modifier_piercing_attack:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end





kingdom_normal_attack = class({})

function kingdom_normal_attack:GetIntrinsicModifierName()
	return "modifier_normal_attack"
end

LinkLuaModifier("modifier_normal_attack", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_normal_attack = class({})

function modifier_normal_attack:IsHidden() return true end
function modifier_normal_attack:IsDebuff() return false end
function modifier_normal_attack:IsPurgable() return false end
function modifier_normal_attack:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end





kingdom_no_armor = class({})

function kingdom_no_armor:GetIntrinsicModifierName()
	return "modifier_no_armor"
end

LinkLuaModifier("modifier_no_armor", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_no_armor = class({})

function modifier_no_armor:IsHidden() return true end
function modifier_no_armor:IsDebuff() return false end
function modifier_no_armor:IsPurgable() return false end
function modifier_no_armor:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end





kingdom_light_armor = class({})

function kingdom_light_armor:GetIntrinsicModifierName()
	return "modifier_light_armor"
end

LinkLuaModifier("modifier_light_armor", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_light_armor = class({})

function modifier_light_armor:IsHidden() return true end
function modifier_light_armor:IsDebuff() return false end
function modifier_light_armor:IsPurgable() return false end
function modifier_light_armor:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end





kingdom_heavy_armor = class({})

function kingdom_heavy_armor:GetIntrinsicModifierName()
	return "modifier_heavy_armor"
end

LinkLuaModifier("modifier_heavy_armor", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_heavy_armor = class({})

function modifier_heavy_armor:IsHidden() return true end
function modifier_heavy_armor:IsDebuff() return false end
function modifier_heavy_armor:IsPurgable() return false end
function modifier_heavy_armor:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end





kingdom_elite_unit = class({})

function kingdom_elite_unit:GetIntrinsicModifierName()
	return "modifier_elite_unit"
end

LinkLuaModifier("modifier_elite_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_elite_unit = class({})

function modifier_elite_unit:IsHidden() return true end
function modifier_elite_unit:IsDebuff() return false end
function modifier_elite_unit:IsPurgable() return false end
function modifier_elite_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_elite_unit:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()
		parent:SetBaseMaxHealth(base_health * 1.2)
		parent:SetMaxHealth(base_health * 1.2)
		parent:SetHealth(base_health * 1.2)

		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())
		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.2 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.2 * damage)
	end
end

function modifier_elite_unit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_elite_unit:GetModifierPhysicalArmorBonus()
	return 2
end

function modifier_elite_unit:GetModifierMoveSpeedBonus_Constant()
	return 50
end

function modifier_elite_unit:GetModifierModelScale()
	return 9
end





kingdom_capital_unit = class({})

function kingdom_capital_unit:GetIntrinsicModifierName()
	return "modifier_capital_unit"
end

LinkLuaModifier("modifier_capital_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_capital_unit = class({})

function modifier_capital_unit:IsHidden() return true end
function modifier_capital_unit:IsDebuff() return false end
function modifier_capital_unit:IsPurgable() return false end
function modifier_capital_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_capital_unit:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()
		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())

		if parent:HasModifier("modifier_elite_unit") then
			base_health = base_health / 1.2
			damage = damage / 1.2
		end

		parent:SetBaseMaxHealth(base_health * 1.4)
		parent:SetMaxHealth(base_health * 1.4)
		parent:SetHealth(base_health * 1.4)

		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.4 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.4 * damage)
	end
end

function modifier_capital_unit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
	return funcs
end

function modifier_capital_unit:GetModifierPhysicalArmorBonus()
	return 4
end

function modifier_capital_unit:GetModifierMoveSpeedBonus_Constant()
	return 100
end

function modifier_capital_unit:GetModifierModelScale()
	return 18
end





kingdom_upgrade_hero = class({})

function kingdom_upgrade_hero:GetIntrinsicModifierName()
	return "modifier_upgrade_hero"
end

LinkLuaModifier("modifier_upgrade_hero", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_upgrade_hero = class({})

function modifier_upgrade_hero:IsHidden() return true end
function modifier_upgrade_hero:IsDebuff() return false end
function modifier_upgrade_hero:IsPurgable() return false end
function modifier_upgrade_hero:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_upgrade_hero:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}
	return funcs
end

function modifier_upgrade_hero:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_upgrade_hero:GetModifierExtraHealthPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_stats")
end





kingdom_human_unit = class({})

function kingdom_human_unit:GetIntrinsicModifierName()
	return "modifier_human_unit"
end

LinkLuaModifier("modifier_human_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_human_unit = class({})

function modifier_human_unit:IsHidden() return true end
function modifier_human_unit:IsDebuff() return false end
function modifier_human_unit:IsPurgable() return false end
function modifier_human_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_unit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_human_unit:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end




kingdom_elf_unit = class({})

function kingdom_elf_unit:GetIntrinsicModifierName()
	return "modifier_elf_unit"
end

LinkLuaModifier("modifier_elf_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_elf_unit = class({})

function modifier_elf_unit:IsHidden() return true end
function modifier_elf_unit:IsDebuff() return false end
function modifier_elf_unit:IsPurgable() return false end
function modifier_elf_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_elf_unit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_elf_unit:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end





kingdom_undead_unit = class({})

function kingdom_undead_unit:GetIntrinsicModifierName()
	return "modifier_undead_unit"
end

LinkLuaModifier("modifier_undead_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_undead_unit = class({})

function modifier_undead_unit:IsHidden() return true end
function modifier_undead_unit:IsDebuff() return false end
function modifier_undead_unit:IsPurgable() return false end
function modifier_undead_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_unit:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()

		parent:SetBaseMaxHealth(base_health * 1.1)
		parent:SetMaxHealth(base_health * 1.1)
		parent:SetHealth(base_health * 1.1)
	end
end





kingdom_keen_unit = class({})

function kingdom_keen_unit:GetIntrinsicModifierName()
	return "modifier_keen_unit"
end

LinkLuaModifier("modifier_keen_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_keen_unit = class({})

function modifier_keen_unit:IsHidden() return true end
function modifier_keen_unit:IsDebuff() return false end
function modifier_keen_unit:IsPurgable() return false end
function modifier_keen_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_unit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_keen_unit:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end





kingdom_orc_unit = class({})

function kingdom_orc_unit:GetIntrinsicModifierName()
	return "modifier_orc_unit"
end

LinkLuaModifier("modifier_orc_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_orc_unit = class({})

function modifier_orc_unit:IsHidden() return true end
function modifier_orc_unit:IsDebuff() return false end
function modifier_orc_unit:IsPurgable() return false end
function modifier_orc_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_unit:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())

		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.2 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.2 * damage)
	end
end





kingdom_demon_unit = class({})

function kingdom_demon_unit:GetIntrinsicModifierName()
	return "modifier_demon_unit"
end

LinkLuaModifier("modifier_demon_unit", "kingdom/abilities/general", LUA_MODIFIER_MOTION_NONE)

modifier_demon_unit = class({})

function modifier_demon_unit:IsHidden() return true end
function modifier_demon_unit:IsDebuff() return false end
function modifier_demon_unit:IsPurgable() return false end
function modifier_demon_unit:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_demon_unit:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()

		parent:SetBaseMaxHealth(base_health * 1.4)
		parent:SetMaxHealth(base_health * 1.4)
		parent:SetHealth(base_health * 1.4)

		local damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())
		parent:SetBaseDamageMax(parent:GetBaseDamageMax() + 0.4 * damage)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin() + 0.4 * damage)
	end
end