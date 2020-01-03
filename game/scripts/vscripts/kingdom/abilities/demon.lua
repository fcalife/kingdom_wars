--	Demonic unit abilities

kingdom_buy_demon_melee = class({})

function kingdom_buy_demon_melee:OnSpellStart()
	EconomyManager:SpawnDemon(self:GetCaster().portal_number, "melee")
	EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_demon_melee:GetGoldCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r1_owner_half") then
		return 4
	else
		return 5
	end
end



kingdom_buy_demon_ranged = class({})

function kingdom_buy_demon_ranged:OnSpellStart()
	EconomyManager:SpawnDemon(self:GetCaster().portal_number, "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_demon_ranged:GetGoldCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r6_owner_half") then
		return 6
	else
		return 7
	end
end



kingdom_buy_demon_cavalry = class({})

function kingdom_buy_demon_cavalry:OnSpellStart()
	EconomyManager:SpawnDemon(self:GetCaster().portal_number, "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_demon_cavalry:GetGoldCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r2_owner_half") then
		return 8
	else
		return 9
	end
end



kingdom_buy_hero_nevermore = class({})

function kingdom_buy_hero_nevermore:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
	PlayerResource:ModifyGold(player_id, 90, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_nevermore:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
		if PlayerResource:GetGold(player_id) >= 90 then
			PlayerResource:SpendGold(player_id, 90, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(caster, 90)

			local hero = EconomyManager:SpawnDemonHero(caster.portal_number, "nevermore")

			hero:EmitSound("Hero_Nevermore.RequiemOfSouls")

			local spawn_pfx = ParticleManager:CreateParticle("heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 3, Vector(256, 1, 1))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_nevermore:GetGoldCost(level)
	return 90
end



kingdom_buy_hero_duchess = class({})

function kingdom_buy_hero_duchess:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
	PlayerResource:ModifyGold(player_id, 90, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_duchess:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
		if PlayerResource:GetGold(player_id) >= 90 then
			PlayerResource:SpendGold(player_id, 90, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(caster, 90)

			local hero = EconomyManager:SpawnDemonHero(caster.portal_number, "duchess")

			hero:EmitSound("Hero_QueenOfPain.ScreamOfPain")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_duchess:GetGoldCost(level)
	return 90
end



kingdom_buy_hero_doom = class({})

function kingdom_buy_hero_doom:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
	PlayerResource:ModifyGold(player_id, 90, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_doom:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
		if PlayerResource:GetGold(player_id) >= 90 then
			PlayerResource:SpendGold(player_id, 90, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToDemonUnitPurchase(caster, 90)

			local hero = EconomyManager:SpawnDemonHero(caster.portal_number, "doom")

			hero:EmitSound("Hero_DoomBringer.Doom")

			Timers:CreateTimer(3.5, function()
				hero:StopSound("Hero_DoomBringer.Doom")
			end)

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())

			Timers:CreateTimer(3.5, function()
				ParticleManager:DestroyParticle(spawn_pfx, true)
				ParticleManager:ReleaseParticleIndex(spawn_pfx)
			end)
		end
	end
end

function kingdom_buy_hero_doom:GetGoldCost(level)
	return 90
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

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

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



kingdom_demon_ranged_ability = class({})

function kingdom_demon_ranged_ability:GetIntrinsicModifierName()
	return "modifier_demon_ranged_ability"
end

LinkLuaModifier("modifier_demon_ranged_ability", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_ranged_ability_effect", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)

modifier_demon_ranged_ability = class({})

function modifier_demon_ranged_ability:IsHidden() return true end
function modifier_demon_ranged_ability:IsDebuff() return false end
function modifier_demon_ranged_ability:IsPurgable() return false end
function modifier_demon_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_demon_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_demon_ranged_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			local ability = self:GetAbility()
			keys.target:AddNewModifier(self:GetParent(), ability, "modifier_demon_ranged_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
		end
	end
end

modifier_demon_ranged_ability_effect = class({})

function modifier_demon_ranged_ability_effect:IsHidden() return false end
function modifier_demon_ranged_ability_effect:IsDebuff() return true end
function modifier_demon_ranged_ability_effect:IsPurgable() return true end
function modifier_demon_ranged_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_demon_ranged_ability_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_demon_ranged_ability_effect:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local total_damage = ability:GetSpecialValueFor("total_damage")
		local damage_tick = parent:GetMaxHealth() * 0.01 * total_damage / ability:GetSpecialValueFor("duration")
		if parent:IsKingdomHero() then
			damage_tick = damage_tick * 0.5
		end

		ApplyDamage({victim = parent, attacker = self:GetCaster(), damage = damage_tick, damage_type = DAMAGE_TYPE_PURE})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , parent, damage_tick, nil)
	end
end

function modifier_demon_ranged_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_demon_ranged_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_demon_ranged_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_demon_ranged_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_4stack.vpcf"
end

function modifier_demon_ranged_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



kingdom_demon_cavalry_ability = class({})

function kingdom_demon_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_demon_cavalry_ability"
end

LinkLuaModifier("modifier_demon_cavalry_ability", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_cavalry_ability_effect", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)

modifier_demon_cavalry_ability = class({})

function modifier_demon_cavalry_ability:IsHidden() return true end
function modifier_demon_cavalry_ability:IsDebuff() return false end
function modifier_demon_cavalry_ability:IsPurgable() return false end
function modifier_demon_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_demon_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_demon_cavalry_ability:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and (not keys.unit:IsAlive()) then
			local parent = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			parent:Heal(parent:GetMaxHealth() * ability:GetSpecialValueFor("heal_pct") * 0.01, parent)
			
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

			local buff_modifier = parent:AddNewModifier(parent, ability, "modifier_demon_cavalry_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
			buff_modifier:SetStackCount(math.min(buff_modifier:GetStackCount() + 1, ability:GetSpecialValueFor("max_stacks")))
		end
	end
end

modifier_demon_cavalry_ability_effect = class({})

function modifier_demon_cavalry_ability_effect:IsHidden() return false end
function modifier_demon_cavalry_ability_effect:IsDebuff() return false end
function modifier_demon_cavalry_ability_effect:IsPurgable() return false end
function modifier_demon_cavalry_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_cavalry_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_demon_cavalry_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") * self:GetStackCount()
end

function modifier_demon_cavalry_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms") * self:GetStackCount()
end



kingdom_demon_nevermore_ability = class({})

function kingdom_demon_nevermore_ability:GetIntrinsicModifierName()
	return "modifier_demon_nevermore_ability"
end

LinkLuaModifier("modifier_demon_nevermore_ability", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_nevermore_ability_effect", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)

modifier_demon_nevermore_ability = class({})

function modifier_demon_nevermore_ability:IsDebuff() return false end
function modifier_demon_nevermore_ability:IsHidden() return true end
function modifier_demon_nevermore_ability:IsPurgable() return false end
function modifier_demon_nevermore_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_nevermore_ability:IsAura()
	return true
end

function modifier_demon_nevermore_ability:GetAuraRadius() return 1200 end
function modifier_demon_nevermore_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_demon_nevermore_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_demon_nevermore_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_demon_nevermore_ability:GetModifierAura() return "modifier_demon_nevermore_ability_effect" end

modifier_demon_nevermore_ability_effect = class({})

function modifier_demon_nevermore_ability_effect:IsHidden() return false end
function modifier_demon_nevermore_ability_effect:IsDebuff() return true end
function modifier_demon_nevermore_ability_effect:IsPurgable() return false end
function modifier_demon_nevermore_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_nevermore_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_demon_nevermore_ability_effect:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end



kingdom_demon_duchess_ability = class({})

function kingdom_demon_duchess_ability:GetIntrinsicModifierName()
	return "modifier_demon_duchess_ability"
end

LinkLuaModifier("modifier_demon_duchess_ability", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_duchess_ability_effect", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)

modifier_demon_duchess_ability = class({})

function modifier_demon_duchess_ability:IsDebuff() return false end
function modifier_demon_duchess_ability:IsHidden() return true end
function modifier_demon_duchess_ability:IsPurgable() return false end
function modifier_demon_duchess_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_duchess_ability:IsAura()
	return true
end

function modifier_demon_duchess_ability:GetAuraRadius() return 1200 end
function modifier_demon_duchess_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_demon_duchess_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_demon_duchess_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_demon_duchess_ability:GetModifierAura() return "modifier_demon_duchess_ability_effect" end

modifier_demon_duchess_ability_effect = class({})

function modifier_demon_duchess_ability_effect:IsHidden() return false end
function modifier_demon_duchess_ability_effect:IsDebuff() return false end
function modifier_demon_duchess_ability_effect:IsPurgable() return false end
function modifier_demon_duchess_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_duchess_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_demon_duchess_ability_effect:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			parent:Heal(keys.damage * ability:GetSpecialValueFor("lifesteal_pct") * 0.01, parent)
			
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		end
	end
end



kingdom_demon_doom_ability = class({})

function kingdom_demon_doom_ability:GetIntrinsicModifierName()
	return "modifier_demon_doom_ability"
end

LinkLuaModifier("modifier_demon_doom_ability", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demon_doom_ability_effect", "kingdom/abilities/demon", LUA_MODIFIER_MOTION_NONE)

modifier_demon_doom_ability = class({})

function modifier_demon_doom_ability:IsDebuff() return false end
function modifier_demon_doom_ability:IsHidden() return true end
function modifier_demon_doom_ability:IsPurgable() return false end
function modifier_demon_doom_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_doom_ability:IsAura()
	return true
end

function modifier_demon_doom_ability:GetAuraRadius() return 400 end
function modifier_demon_doom_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_demon_doom_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_demon_doom_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_demon_doom_ability:GetModifierAura() return "modifier_demon_doom_ability_effect" end

modifier_demon_doom_ability_effect = class({})

function modifier_demon_doom_ability_effect:IsHidden() return false end
function modifier_demon_doom_ability_effect:IsDebuff() return true end
function modifier_demon_doom_ability_effect:IsPurgable() return false end
function modifier_demon_doom_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_demon_doom_ability_effect:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_demon_doom_ability_effect:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local damage_tick = parent:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("dps") * 0.01 * 0.5
		if parent:IsKingdomHero() then
			damage_tick = damage_tick * 0.5
		end
		ApplyDamage({victim = parent, attacker = self:GetCaster(), damage = damage_tick, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE , parent, damage_tick, nil)
	end
end