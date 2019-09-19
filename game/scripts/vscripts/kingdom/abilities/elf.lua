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



kingdom_elf_ranged_ability = class({})

function kingdom_elf_ranged_ability:GetIntrinsicModifierName()
	return "modifier_elf_ranged_ability"
end

LinkLuaModifier("modifier_elf_ranged_ability", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_elf_ranged_ability = class({})

function modifier_elf_ranged_ability:IsHidden() return true end
function modifier_elf_ranged_ability:IsDebuff() return false end
function modifier_elf_ranged_ability:IsPurgable() return false end
function modifier_elf_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_elf_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_elf_ranged_ability:GetModifierAttackRangeBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_range")
end

function modifier_elf_ranged_ability:GetBonusDayVision()
	return self:GetAbility():GetSpecialValueFor("bonus_range")
end

function modifier_elf_ranged_ability:GetBonusNightVision()
	return self:GetAbility():GetSpecialValueFor("bonus_range")
end

function modifier_elf_ranged_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage") * math.min(1, (parent:GetAbsOrigin() - keys.target:GetAbsOrigin()):Length2D() / 900)
			ApplyDamage({victim = keys.target, attacker = parent, damage = bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end



kingdom_elf_cavalry_ability = class({})

function kingdom_elf_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_elf_cavalry_ability"
end

function kingdom_elf_cavalry_ability:OnProjectileHit(target, location)
	if IsServer() then
		ApplyDamage({victim = target, attacker = self:GetCaster(), damage = 140 * self:GetSpecialValueFor("bounce_damage") * 0.01, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

LinkLuaModifier("modifier_elf_cavalry_ability", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_elf_cavalry_ability = class({})

function modifier_elf_cavalry_ability:IsHidden() return true end
function modifier_elf_cavalry_ability:IsDebuff() return false end
function modifier_elf_cavalry_ability:IsPurgable() return false end
function modifier_elf_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_elf_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_elf_cavalry_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local enemies = FindUnitsInRadius(parent:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, ability:GetSpecialValueFor("bounce_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if enemy ~= keys.target then
					local glaive_projectile = {
						Target = enemy,
						Source = parent,
						Ability = ability,
						EffectName = "particles/units/heroes/hero_luna/luna_moon_glaive_bounce.vpcf",
						iMoveSpeed = 900,
						bDodgeable = false,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false,
						iVisionRadius = 300,
						iVisionTeamNumber = parent:GetTeamNumber()
					}
					ProjectileManager:CreateTrackingProjectile(glaive_projectile)
					break
				end
			end
		end
	end
end