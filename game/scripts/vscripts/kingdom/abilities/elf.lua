--	Elven unit abilities

kingdom_buy_elf_melee = class({})

function kingdom_buy_elf_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_elf_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_elf_ranged = class({})

function kingdom_buy_elf_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_elf_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_elf_cavalry = class({})

function kingdom_buy_elf_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_elf_cavalry:GetGoldCost(level)
	return 5
end



kingdom_elf_melee_ability = class({})

function kingdom_elf_melee_ability:GetIntrinsicModifierName()
	return "modifier_elf_melee_ability"
end

LinkLuaModifier("modifier_elf_melee_ability", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_elf_melee_ability = class({})

function modifier_elf_melee_ability:IsHidden() return true end
function modifier_elf_melee_ability:IsDebuff() return false end
function modifier_elf_melee_ability:IsPurgable() return false end
function modifier_elf_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_elf_melee_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_elf_melee_ability:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_resist")
end