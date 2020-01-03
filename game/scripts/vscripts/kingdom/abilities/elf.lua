--	Elven unit abilities

kingdom_buy_elf_melee = class({})

function kingdom_buy_elf_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_elf_melee:GetGoldCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r1_owner_half") then
		return 4
	else
		return 5
	end
end



kingdom_buy_elf_ranged = class({})

function kingdom_buy_elf_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_elf_ranged:GetGoldCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r6_owner_half") then
		return 6
	else
		return 7
	end
end



kingdom_buy_elf_cavalry = class({})

function kingdom_buy_elf_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_elf_cavalry:GetGoldCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r2_owner_half") then
		return 8
	else
		return 9
	end
end



kingdom_buy_hero_ranger = class({})

function kingdom_buy_hero_ranger:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_ranger:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_DrowRanger.Silence")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(256, 256, 256))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_ranger:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_druid = class({})

function kingdom_buy_hero_druid:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_druid:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Furion.Sprout")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_druid:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_assassin = class({})

function kingdom_buy_hero_assassin:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_assassin:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_PhantomAssassin.CoupDeGrace")

			hero:AddNewModifier(hero, self, "modifier_hero_assassin_spawn_fx", {duration = 4})
		end
	end
end

function kingdom_buy_hero_assassin:GetGoldCost(level)
	return 60
end

LinkLuaModifier("modifier_hero_assassin_spawn_fx", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_hero_assassin_spawn_fx = class({})

function modifier_hero_assassin_spawn_fx:IsHidden() return true end
function modifier_hero_assassin_spawn_fx:IsDebuff() return false end
function modifier_hero_assassin_spawn_fx:IsPurgable() return false end
function modifier_hero_assassin_spawn_fx:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_hero_assassin_spawn_fx:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
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

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			local bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage") * math.min(1, (parent:GetAbsOrigin() - keys.target:GetAbsOrigin()):Length2D() / 900) * 0.01
			local base_damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())
			ApplyDamage({victim = keys.target, attacker = parent, damage = base_damage * bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end



kingdom_elf_cavalry_ability = class({})

function kingdom_elf_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_elf_cavalry_ability"
end

function kingdom_elf_cavalry_ability:OnProjectileHit(target, location)
	if IsServer() then
		local base_damage = 0.5 * (self:GetCaster():GetBaseDamageMax() + self:GetCaster():GetBaseDamageMin())
		local bonus_damage = base_damage * self:GetSpecialValueFor("bounce_damage") * 0.01
		ApplyDamage({victim = target, attacker = self:GetCaster(), damage = bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
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

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

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



kingdom_elf_ranger_ability = class({})

function kingdom_elf_ranger_ability:GetIntrinsicModifierName()
	return "modifier_elf_ranger_ability"
end

LinkLuaModifier("modifier_elf_ranger_ability", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elf_ranger_ability_effect", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_elf_ranger_ability = class({})

function modifier_elf_ranger_ability:IsDebuff() return false end
function modifier_elf_ranger_ability:IsHidden() return true end
function modifier_elf_ranger_ability:IsPurgable() return false end
function modifier_elf_ranger_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_elf_ranger_ability:IsAura()
	return true
end

function modifier_elf_ranger_ability:GetAuraRadius() return 1200 end
function modifier_elf_ranger_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_RANGED_ONLY end
function modifier_elf_ranger_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_elf_ranger_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_elf_ranger_ability:GetModifierAura() return "modifier_elf_ranger_ability_effect" end

modifier_elf_ranger_ability_effect = class({})

function modifier_elf_ranger_ability_effect:IsHidden() return false end
function modifier_elf_ranger_ability_effect:IsDebuff() return false end
function modifier_elf_ranger_ability_effect:IsPurgable() return false end
function modifier_elf_ranger_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_elf_ranger_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_elf_ranger_ability_effect:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end



kingdom_elf_druid_ability = class({})

function kingdom_elf_druid_ability:GetIntrinsicModifierName()
	return "modifier_elf_druid_ability"
end

LinkLuaModifier("modifier_elf_druid_ability", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elf_druid_ability_effect", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_elf_druid_ability = class({})

function modifier_elf_druid_ability:IsDebuff() return false end
function modifier_elf_druid_ability:IsHidden() return true end
function modifier_elf_druid_ability:IsPurgable() return false end
function modifier_elf_druid_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_elf_druid_ability:IsAura()
	return true
end

function modifier_elf_druid_ability:GetAuraRadius() return 1200 end
function modifier_elf_druid_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_elf_druid_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_elf_druid_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_elf_druid_ability:GetModifierAura() return "modifier_elf_druid_ability_effect" end

modifier_elf_druid_ability_effect = class({})

function modifier_elf_druid_ability_effect:IsHidden() return false end
function modifier_elf_druid_ability_effect:IsDebuff() return false end
function modifier_elf_druid_ability_effect:IsPurgable() return false end
function modifier_elf_druid_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_elf_druid_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_elf_druid_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end



kingdom_elf_assassin_ability = class({})

function kingdom_elf_assassin_ability:GetIntrinsicModifierName()
	return "modifier_elf_assassin_ability"
end

LinkLuaModifier("modifier_elf_assassin_ability", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elf_assassin_ability_effect", "kingdom/abilities/elf", LUA_MODIFIER_MOTION_NONE)

modifier_elf_assassin_ability = class({})

function modifier_elf_assassin_ability:IsDebuff() return false end
function modifier_elf_assassin_ability:IsHidden() return true end
function modifier_elf_assassin_ability:IsPurgable() return false end
function modifier_elf_assassin_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_elf_assassin_ability:IsAura()
	return true
end

function modifier_elf_assassin_ability:GetAuraRadius() return 1200 end
function modifier_elf_assassin_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_elf_assassin_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_elf_assassin_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_elf_assassin_ability:GetModifierAura() return "modifier_elf_assassin_ability_effect" end

modifier_elf_assassin_ability_effect = class({})

function modifier_elf_assassin_ability_effect:IsHidden() return false end
function modifier_elf_assassin_ability_effect:IsDebuff() return false end
function modifier_elf_assassin_ability_effect:IsPurgable() return false end
function modifier_elf_assassin_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_elf_assassin_ability_effect:CheckState()
	local states = {
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true
	}
	return states
end

function modifier_elf_assassin_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return funcs
end

function modifier_elf_assassin_ability_effect:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end