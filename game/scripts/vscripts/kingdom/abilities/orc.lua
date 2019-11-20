--	Orcish unit abilities

kingdom_buy_orc_melee = class({})

function kingdom_buy_orc_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), 5)
end

function kingdom_buy_orc_melee:GetGoldCost(level)
	return 5
end



kingdom_buy_orc_ranged = class({})

function kingdom_buy_orc_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), 8)
end

function kingdom_buy_orc_ranged:GetGoldCost(level)
	return 8
end



kingdom_buy_orc_cavalry = class({})

function kingdom_buy_orc_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), 10)
end

function kingdom_buy_orc_cavalry:GetGoldCost(level)
	return 10
end



kingdom_buy_hero_incursor = class({})

function kingdom_buy_hero_incursor:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_incursor:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Disruptor.ThunderStrike.Cast")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(0, 0, 1000))

			Timers:CreateTimer(1, function()
				hero:EmitSound("Hero_Disruptor.ThunderStrike.Target")
			end)

			Timers:CreateTimer(2, function()
				hero:EmitSound("Hero_Disruptor.ThunderStrike.Target")
			end)

			Timers:CreateTimer(2, function()
				ParticleManager:DestroyParticle(spawn_pfx, false)
				ParticleManager:ReleaseParticleIndex(spawn_pfx)
			end)
		end
	end
end

function kingdom_buy_hero_incursor:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_warlord = class({})

function kingdom_buy_hero_warlord:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_warlord:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_ElderTitan.EchoStomp")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(256, 0, 0))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_warlord:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_blademaster = class({})

function kingdom_buy_hero_blademaster:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_blademaster:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Juggernaut.BladeFuryStart")

			Timers:CreateTimer(3, function()
				hero:StopSound("Hero_Juggernaut.BladeFuryStart")
				hero:EmitSound("Hero_Juggernaut.BladeFuryStop")
			end)

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 5, Vector(256, 0, 0))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)

			Timers:CreateTimer(3, function()
				ParticleManager:DestroyParticle(spawn_pfx, false)
				ParticleManager:ReleaseParticleIndex(spawn_pfx)
			end)
		end
	end
end

function kingdom_buy_hero_blademaster:GetGoldCost(level)
	return 60
end



kingdom_orc_melee_ability = class({})

function kingdom_orc_melee_ability:GetIntrinsicModifierName()
	return "modifier_orc_melee_ability"
end

LinkLuaModifier("modifier_orc_melee_ability", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orc_melee_ability_animation", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)

modifier_orc_melee_ability = class({})

function modifier_orc_melee_ability:IsHidden() return true end
function modifier_orc_melee_ability:IsDebuff() return false end
function modifier_orc_melee_ability:IsPurgable() return false end
function modifier_orc_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_melee_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_orc_melee_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.target == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			if RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then
				local parent = self:GetParent()
				local ability = self:GetAbility()
				if (parent:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Length2D() <= ability:GetSpecialValueFor("max_range") then
					parent:EmitSound("BattleReflexes.Proc")
					parent:AddNewModifier(parent, ability, "modifier_orc_melee_ability_animation", {duration = 0.5})
					Timers:CreateTimer(0.01, function()
						parent:PerformAttack(keys.attacker, true, true, true, false, true, false, false)
					end)
				end
			end
		end
	end
end

modifier_orc_melee_ability_animation = class({})

function modifier_orc_melee_ability_animation:IsHidden() return true end
function modifier_orc_melee_ability_animation:IsDebuff() return false end
function modifier_orc_melee_ability_animation:IsPurgable() return false end
function modifier_orc_melee_ability_animation:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_melee_ability_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_orc_melee_ability_animation:GetOverrideAnimation(keys)
	return ACT_DOTA_CAST_ABILITY_3
end



kingdom_orc_ranged_ability = class({})

function kingdom_orc_ranged_ability:GetIntrinsicModifierName()
	return "modifier_orc_ranged_ability"
end

LinkLuaModifier("modifier_orc_ranged_ability", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orc_ranged_ability_effect", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)

modifier_orc_ranged_ability = class({})

function modifier_orc_ranged_ability:IsHidden() return true end
function modifier_orc_ranged_ability:IsDebuff() return false end
function modifier_orc_ranged_ability:IsPurgable() return false end
function modifier_orc_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_orc_ranged_ability:OnAttackStart(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_orc_ranged_ability_effect", {})
			end
		end
	end
end

function modifier_orc_ranged_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			self:GetParent():RemoveModifierByName("modifier_orc_ranged_ability_effect")
		end
	end
end

modifier_orc_ranged_ability_effect = class({})

function modifier_orc_ranged_ability_effect:IsHidden() return true end
function modifier_orc_ranged_ability_effect:IsDebuff() return false end
function modifier_orc_ranged_ability_effect:IsPurgable() return false end
function modifier_orc_ranged_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_ranged_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return funcs
end

function modifier_orc_ranged_ability_effect:GetModifierPreAttack_CriticalStrike()
	return self:GetAbility():GetSpecialValueFor("crit_damage")
end



kingdom_orc_cavalry_ability = class({})

function kingdom_orc_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_orc_cavalry_ability"
end

LinkLuaModifier("modifier_orc_cavalry_ability", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orc_cavalry_ability_effect", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)

modifier_orc_cavalry_ability = class({})

function modifier_orc_cavalry_ability:IsHidden() return true end
function modifier_orc_cavalry_ability:IsDebuff() return false end
function modifier_orc_cavalry_ability:IsPurgable() return false end
function modifier_orc_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_orc_cavalry_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			local ability = self:GetAbility()
			keys.target:EmitSound("StickyNapalm.Hit")
			keys.target:AddNewModifier(self:GetParent(), ability, "modifier_orc_cavalry_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
		end
	end
end

modifier_orc_cavalry_ability_effect = class({})

function modifier_orc_cavalry_ability_effect:IsHidden() return false end
function modifier_orc_cavalry_ability_effect:IsDebuff() return true end
function modifier_orc_cavalry_ability_effect:IsPurgable() return true end
function modifier_orc_cavalry_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_orc_cavalry_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_orc_cavalry_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return (-1) * self:GetAbility():GetSpecialValueFor("move_slow")
end

function modifier_orc_cavalry_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return (-1) * self:GetAbility():GetSpecialValueFor("as_slow")
end

function modifier_orc_cavalry_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf"
end

function modifier_orc_cavalry_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_orc_cavalry_ability_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_stickynapalm.vpcf"
end

function modifier_orc_cavalry_ability_effect:StatusEffectPriority()
	return 10
end



kingdom_orc_incursor_ability = class({})

function kingdom_orc_incursor_ability:GetIntrinsicModifierName()
	return "modifier_orc_incursor_ability"
end

LinkLuaModifier("modifier_orc_incursor_ability", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orc_incursor_ability_effect", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)

modifier_orc_incursor_ability = class({})

function modifier_orc_incursor_ability:IsDebuff() return false end
function modifier_orc_incursor_ability:IsHidden() return true end
function modifier_orc_incursor_ability:IsPurgable() return false end
function modifier_orc_incursor_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orc_incursor_ability:IsAura()
	return true
end

function modifier_orc_incursor_ability:GetAuraRadius() return 1200 end
function modifier_orc_incursor_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_orc_incursor_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_orc_incursor_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_orc_incursor_ability:GetModifierAura() return "modifier_orc_incursor_ability_effect" end

modifier_orc_incursor_ability_effect = class({})

function modifier_orc_incursor_ability_effect:IsHidden() return false end
function modifier_orc_incursor_ability_effect:IsDebuff() return false end
function modifier_orc_incursor_ability_effect:IsPurgable() return false end
function modifier_orc_incursor_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orc_incursor_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_orc_incursor_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end



kingdom_orc_warlord_ability = class({})

function kingdom_orc_warlord_ability:GetIntrinsicModifierName()
	return "modifier_orc_warlord_ability"
end

LinkLuaModifier("modifier_orc_warlord_ability", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orc_warlord_ability_effect", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)

modifier_orc_warlord_ability = class({})

function modifier_orc_warlord_ability:IsDebuff() return false end
function modifier_orc_warlord_ability:IsHidden() return true end
function modifier_orc_warlord_ability:IsPurgable() return false end
function modifier_orc_warlord_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orc_warlord_ability:IsAura()
	return true
end

function modifier_orc_warlord_ability:GetAuraRadius() return 1200 end
function modifier_orc_warlord_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_orc_warlord_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_orc_warlord_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_orc_warlord_ability:GetModifierAura() return "modifier_orc_warlord_ability_effect" end

modifier_orc_warlord_ability_effect = class({})

function modifier_orc_warlord_ability_effect:IsHidden() return false end
function modifier_orc_warlord_ability_effect:IsDebuff() return false end
function modifier_orc_warlord_ability_effect:IsPurgable() return false end
function modifier_orc_warlord_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orc_warlord_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_orc_warlord_ability_effect:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end



kingdom_orc_blademaster_ability = class({})

function kingdom_orc_blademaster_ability:GetIntrinsicModifierName()
	return "modifier_orc_blademaster_ability"
end

LinkLuaModifier("modifier_orc_blademaster_ability", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_orc_blademaster_ability_effect", "kingdom/abilities/orc", LUA_MODIFIER_MOTION_NONE)

modifier_orc_blademaster_ability = class({})

function modifier_orc_blademaster_ability:IsDebuff() return false end
function modifier_orc_blademaster_ability:IsHidden() return true end
function modifier_orc_blademaster_ability:IsPurgable() return false end
function modifier_orc_blademaster_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orc_blademaster_ability:IsAura()
	return true
end

function modifier_orc_blademaster_ability:GetAuraRadius() return 1200 end
function modifier_orc_blademaster_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_orc_blademaster_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_orc_blademaster_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_orc_blademaster_ability:GetModifierAura() return "modifier_orc_blademaster_ability_effect" end

modifier_orc_blademaster_ability_effect = class({})

function modifier_orc_blademaster_ability_effect:IsHidden() return false end
function modifier_orc_blademaster_ability_effect:IsDebuff() return true end
function modifier_orc_blademaster_ability_effect:IsPurgable() return false end
function modifier_orc_blademaster_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orc_blademaster_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_orc_blademaster_ability_effect:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_reduction")
end