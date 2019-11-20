--	Undead unit abilities

kingdom_buy_undead_melee = class({})

function kingdom_buy_undead_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), 6)
end

function kingdom_buy_undead_melee:GetGoldCost(level)
	return 6
end



kingdom_buy_undead_ranged = class({})

function kingdom_buy_undead_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), 8)
end

function kingdom_buy_undead_ranged:GetGoldCost(level)
	return 8
end



kingdom_buy_undead_cavalry = class({})

function kingdom_buy_undead_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), 10)
end

function kingdom_buy_undead_cavalry:GetGoldCost(level)
	return 10
end



kingdom_buy_hero_necromancer = class({})

function kingdom_buy_hero_necromancer:OnSpellStart()
	local caster = self:GetCaster()
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 40)

	local hero = EconomyManager:SpawnHero(caster:GetRegion(), caster:GetCity())
	hero:EmitSound("Hero_Necrolyte.SpiritForm.Cast")
	hero:AddNewModifier(hero, self, "modifier_hero_necromancer_spawn_fx", {duration = 4})
end

function kingdom_buy_hero_necromancer:GetGoldCost(level)
	return 40
end

LinkLuaModifier("modifier_hero_necromancer_spawn_fx", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_hero_necromancer_spawn_fx = class({})

function modifier_hero_necromancer_spawn_fx:IsHidden() return true end
function modifier_hero_necromancer_spawn_fx:IsDebuff() return false end
function modifier_hero_necromancer_spawn_fx:IsPurgable() return false end
function modifier_hero_necromancer_spawn_fx:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_hero_necromancer_spawn_fx:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end



kingdom_buy_hero_wraith_king = class({})

function kingdom_buy_hero_wraith_king:OnSpellStart()
	local caster = self:GetCaster()
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 40)

	local hero = EconomyManager:SpawnHero(caster:GetRegion(), caster:GetCity())
	hero:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")

	local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(2, 0, 0))
	ParticleManager:ReleaseParticleIndex(spawn_pfx)
end

function kingdom_buy_hero_wraith_king:GetGoldCost(level)
	return 40
end



kingdom_buy_hero_butcher = class({})

function kingdom_buy_hero_butcher:OnSpellStart()
	local caster = self:GetCaster()
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 40)

	local hero = EconomyManager:SpawnHero(caster:GetRegion(), caster:GetCity())
	hero:EmitSound("Hero_Pudge.DismemberSwings")

	local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_rot.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(256, 0, 0))

	Timers:CreateTimer(4, function()
		ParticleManager:DestroyParticle(spawn_pfx, false)
		ParticleManager:ReleaseParticleIndex(spawn_pfx)
	end)
end

function kingdom_buy_hero_butcher:GetGoldCost(level)
	return 40
end



kingdom_undead_melee_ability = class({})

function kingdom_undead_melee_ability:GetIntrinsicModifierName()
	return "modifier_undead_melee_ability"
end

LinkLuaModifier("modifier_undead_melee_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undead_melee_ability_effect", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_melee_ability = class({})

function modifier_undead_melee_ability:IsHidden() return true end
function modifier_undead_melee_ability:IsDebuff() return false end
function modifier_undead_melee_ability:IsPurgable() return false end
function modifier_undead_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_melee_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_undead_melee_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_undead_melee_ability_effect", {duration = self:GetAbility():GetSpecialValueFor("plague_duration")})
		end
	end
end

modifier_undead_melee_ability_effect = class({})

function modifier_undead_melee_ability_effect:IsHidden() return false end
function modifier_undead_melee_ability_effect:IsDebuff() return true end
function modifier_undead_melee_ability_effect:IsPurgable() return false end
function modifier_undead_melee_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_melee_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_undead_melee_ability_effect:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local unit_name = keys.unit:GetUnitName()
			local should_count = true

			local undead_units = {
				"npc_kingdom_undead_melee",
				"npc_kingdom_undead_ranged",
				"npc_kingdom_undead_cavalry",
				"npc_kingdom_hero_necromancer",
				"npc_kingdom_hero_wraith_king",
				"npc_kingdom_hero_butcher"
			}

			for _, undead_unit_name in pairs(undead_units) do
				if unit_name == undead_unit_name then
					should_count = false
				end
			end

			if should_count then
				local player = Kingdom:GetPlayerByTeam(self:GetCaster():GetTeam())
				local player_id = Kingdom:GetPlayerID(player)
				local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)

				Timers:CreateTimer(3, function()
					local unit = CreateUnitByName("npc_kingdom_undead_melee", self:GetParent():GetAbsOrigin(), true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
					unit:SetHealth(unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("zombie_health") * 0.01)
					unit:SetControllableByPlayer(player_id, true)
					Timers:CreateTimer(0.1, function()
						ResolveNPCPositions(unit:GetAbsOrigin(), 128)
					end)
				end)
			end
		end
	end
end



kingdom_undead_ranged_ability = class({})

function kingdom_undead_ranged_ability:GetIntrinsicModifierName()
	return "modifier_undead_ranged_ability"
end

LinkLuaModifier("modifier_undead_ranged_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_ranged_ability = class({})

function modifier_undead_ranged_ability:IsHidden() return true end
function modifier_undead_ranged_ability:IsDebuff() return false end
function modifier_undead_ranged_ability:IsPurgable() return false end
function modifier_undead_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_undead_ranged_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			if RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then
				local parent = self:GetParent()
				local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
				for _, enemy in pairs(enemies) do
					if enemy ~= keys.target then
						parent:PerformAttack(enemy, true, true, true, false, true, false, false)
						break
					end
				end
			end
		end
	end
end



kingdom_undead_cavalry_ability = class({})

function kingdom_undead_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_undead_cavalry_ability"
end

LinkLuaModifier("modifier_undead_cavalry_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_cavalry_ability = class({})

function modifier_undead_cavalry_ability:IsHidden() return true end
function modifier_undead_cavalry_ability:IsDebuff() return false end
function modifier_undead_cavalry_ability:IsPurgable() return false end
function modifier_undead_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_undead_cavalry_ability:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			local spawn_loc = self:GetParent():GetAbsOrigin()
			local new_health = self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("return_health") * 0.01
			local player_id = self:GetParent():GetOwnerEntity():GetPlayerID()
			local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)

			Timers:CreateTimer(3, function()
				local return_pfx = ParticleManager:CreateParticle("particles/returned.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(return_pfx, 0, spawn_loc)
				ParticleManager:ReleaseParticleIndex(return_pfx)

				local new_unit = CreateUnitByName("npc_kingdom_undead_cavalry", spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
				new_unit:SetControllableByPlayer(player_id, true)
				new_unit:SetHealth(new_health)
				new_unit:RemoveAbility("kingdom_undead_cavalry_ability")
				new_unit:RemoveModifierByName("modifier_undead_cavalry_ability")
				new_unit:EmitSound("Return.Reincarnation")
				Timers:CreateTimer(0.1, function()
					ResolveNPCPositions(new_unit:GetAbsOrigin(), 128)
				end)
			end)
		end
	end	
end



kingdom_undead_necromancer_ability = class({})

function kingdom_undead_necromancer_ability:GetIntrinsicModifierName()
	return "modifier_undead_necromancer_ability"
end

LinkLuaModifier("modifier_undead_necromancer_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undead_necromancer_ability_effect", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_necromancer_ability = class({})

function modifier_undead_necromancer_ability:IsDebuff() return false end
function modifier_undead_necromancer_ability:IsHidden() return true end
function modifier_undead_necromancer_ability:IsPurgable() return false end
function modifier_undead_necromancer_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_undead_necromancer_ability:IsAura()
	return true
end

function modifier_undead_necromancer_ability:GetAuraRadius() return 1200 end
function modifier_undead_necromancer_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_undead_necromancer_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_undead_necromancer_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_undead_necromancer_ability:GetModifierAura() return "modifier_undead_necromancer_ability_effect" end

modifier_undead_necromancer_ability_effect = class({})

function modifier_undead_necromancer_ability_effect:IsHidden() return true end
function modifier_undead_necromancer_ability_effect:IsDebuff() return false end
function modifier_undead_necromancer_ability_effect:IsPurgable() return false end
function modifier_undead_necromancer_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_undead_necromancer_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_undead_necromancer_ability_effect:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local unit_name = keys.unit:GetUnitName()
			local should_count = true
			local undead_units = {
				"npc_kingdom_undead_melee",
				"npc_kingdom_undead_ranged",
				"npc_kingdom_undead_cavalry",
				"npc_kingdom_hero_necromancer",
				"npc_kingdom_hero_wraith_king",
				"npc_kingdom_hero_butcher"
			}

			for _, undead_unit_name in pairs(undead_units) do
				if unit_name == undead_unit_name then
					should_count = false
				end
			end

			if should_count then
				local caster = self:GetCaster()
				local unit_count_modifier = caster:FindModifierByName("modifier_undead_necromancer_ability")
				unit_count_modifier:IncrementStackCount()
				if unit_count_modifier:GetStackCount() >= self:GetAbility():GetSpecialValueFor("raise_units") then
					unit_count_modifier:SetStackCount(0)

					local player = Kingdom:GetPlayerByTeam(caster:GetTeam())
					local player_id = Kingdom:GetPlayerID(player)
					local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
					local unit = CreateUnitByName("npc_kingdom_undead_melee", caster:GetAbsOrigin() + RandomVector(150), true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
					unit:SetControllableByPlayer(player_id, true)
					Timers:CreateTimer(0.1, function()
						ResolveNPCPositions(unit:GetAbsOrigin(), 128)
					end)
				end
			end
		end
	end
end



kingdom_undead_wraith_king_ability = class({})

function kingdom_undead_wraith_king_ability:GetIntrinsicModifierName()
	return "modifier_undead_wraith_king_ability"
end

LinkLuaModifier("modifier_undead_wraith_king_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undead_wraith_king_ability_effect", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_wraith_king_ability = class({})

function modifier_undead_wraith_king_ability:IsHidden() return true end
function modifier_undead_wraith_king_ability:IsDebuff() return false end
function modifier_undead_wraith_king_ability:IsPurgable() return false end
function modifier_undead_wraith_king_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_wraith_king_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_undead_wraith_king_ability:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			if parent:GetHealth() < ability:GetSpecialValueFor("wraith_health") and ability:IsCooldownReady() then
				parent:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
				parent:AddNewModifier(parent, ability, "modifier_undead_wraith_king_ability_effect", {duration = ability:GetSpecialValueFor("wraith_duration")})
				ability:UseResources(false, false, true)
			end
		end
	end
end



modifier_undead_wraith_king_ability_effect = class({})

function modifier_undead_wraith_king_ability_effect:IsHidden() return false end
function modifier_undead_wraith_king_ability_effect:IsDebuff() return false end
function modifier_undead_wraith_king_ability_effect:IsPurgable() return false end
function modifier_undead_wraith_king_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_wraith_king_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_undead_wraith_king_ability_effect:GetModifierIncomingPhysicalDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_undead_wraith_king_ability_effect:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("magic_resistance")
end

function modifier_undead_wraith_king_ability_effect:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			parent:Heal(keys.damage * ability:GetSpecialValueFor("wraith_lifesteal") * 0.01, parent)
			
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		end
	end
end

function modifier_undead_wraith_king_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf"
end

function modifier_undead_wraith_king_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_undead_wraith_king_ability_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function modifier_undead_wraith_king_ability_effect:StatusEffectPriority()
	return 10
end



kingdom_undead_butcher_ability = class({})

function kingdom_undead_butcher_ability:GetIntrinsicModifierName()
	return "modifier_undead_butcher_ability"
end

LinkLuaModifier("modifier_undead_butcher_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undead_butcher_ability_effect", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_butcher_ability = class({})

function modifier_undead_butcher_ability:IsDebuff() return false end
function modifier_undead_butcher_ability:IsHidden() return true end
function modifier_undead_butcher_ability:IsPurgable() return false end
function modifier_undead_butcher_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_undead_butcher_ability:IsAura()
	return true
end

function modifier_undead_butcher_ability:GetAuraRadius() return 1200 end
function modifier_undead_butcher_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_undead_butcher_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_undead_butcher_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_undead_butcher_ability:GetModifierAura() return "modifier_undead_butcher_ability_effect" end

modifier_undead_butcher_ability_effect = class({})

function modifier_undead_butcher_ability_effect:IsHidden() return false end
function modifier_undead_butcher_ability_effect:IsDebuff() return true end
function modifier_undead_butcher_ability_effect:IsPurgable() return false end
function modifier_undead_butcher_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_undead_butcher_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_undead_butcher_ability_effect:GetDisableHealing()
	return 1
end

function modifier_undead_butcher_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("move_slow")
end