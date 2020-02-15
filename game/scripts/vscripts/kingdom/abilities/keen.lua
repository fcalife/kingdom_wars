--	Keenfolk unit abilities

kingdom_buy_keen_melee = class({})

function kingdom_buy_keen_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_keen_melee:GetGoldCost(level)
	local price = 5
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r1_contender") then
		price = price - 1
	end
	if caster:HasModifier("modifier_kingdom_r5_owner") then
		price = price - 1
	end
	return price
end



kingdom_buy_keen_ranged = class({})

function kingdom_buy_keen_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_keen_ranged:GetGoldCost(level)
	local price = 7
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r6_contender") then
		price = price - 1
	end
	if caster:HasModifier("modifier_kingdom_r5_owner") then
		price = price - 1
	end
	return price
end



kingdom_buy_keen_cavalry = class({})

function kingdom_buy_keen_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_keen_cavalry:GetGoldCost(level)
	local price = 9
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_kingdom_r2_contender") then
		price = price - 1
	end
	if caster:HasModifier("modifier_kingdom_r5_owner") then
		price = price - 1
	end
	return price
end



kingdom_buy_hero_bounty_hunter = class({})

function kingdom_buy_hero_bounty_hunter:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_bounty_hunter:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_BountyHunter.WindWalk")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_bounty_hunter:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_tinker = class({})

function kingdom_buy_hero_tinker:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_tinker:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Tinker.March_of_the_Machines.Cast")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_motm.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(spawn_pfx)

			hero:AddNewModifier(hero, self, "modifier_hero_tinker_spawn_fx", {duration = 4})
		end
	end
end

function kingdom_buy_hero_tinker:GetGoldCost(level)
	return 60
end

LinkLuaModifier("modifier_hero_tinker_spawn_fx", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_hero_tinker_spawn_fx = class({})

function modifier_hero_tinker_spawn_fx:IsHidden() return true end
function modifier_hero_tinker_spawn_fx:IsDebuff() return false end
function modifier_hero_tinker_spawn_fx:IsPurgable() return false end
function modifier_hero_tinker_spawn_fx:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_hero_tinker_spawn_fx:GetEffectName()
	return "particles/units/heroes/hero_tinker/tinker_rearm.vpcf"
end



kingdom_buy_hero_engineer = class({})

function kingdom_buy_hero_engineer:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_engineer:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Gyrocopter.CallDown.Fire")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 3, hero:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_engineer:GetGoldCost(level)
	return 60
end



kingdom_keen_melee_ability = class({})

function kingdom_keen_melee_ability:GetIntrinsicModifierName()
	return "modifier_keen_melee_ability"
end

LinkLuaModifier("modifier_keen_melee_ability", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keen_melee_ability_target", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keen_melee_ability_dash", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_keen_melee_ability = class({})

function modifier_keen_melee_ability:IsHidden() return true end
function modifier_keen_melee_ability:IsDebuff() return false end
function modifier_keen_melee_ability:IsPurgable() return false end
function modifier_keen_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_melee_ability:OnCreated(keys)
	if IsServer() then
		self.stacks = 0
		self:StartIntervalThink(0.5)
	end
end

function modifier_keen_melee_ability:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if ability:IsCooldownReady() and parent:IsAlive() then
			local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, ability:GetSpecialValueFor("latch_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			if #enemies > 0 then
				for i = 1, #enemies do
					if (not enemies[i]:HasModifier("modifier_stunned")) and (not enemies[i]:HasModifier("modifier_keen_melee_ability_target"))then
						self:Launch(parent, enemies[i])
						ability:UseResources(false, false, true)
						break
					end
				end
			end
		end
	end
end

function modifier_keen_melee_ability:Launch(caster, target)
	local ability = self:GetAbility()
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()
	local speed = ability:GetSpecialValueFor("latch_speed")
	local distance = (target_loc - caster_loc):Length2D()
	local hit_delay = distance / speed

	caster.hook_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_hookshot.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.hook_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon", caster_loc, true)
	ParticleManager:SetParticleControlEnt(caster.hook_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)
	ParticleManager:SetParticleControl(caster.hook_pfx, 2, Vector(speed, 0, 0))
	ParticleManager:SetParticleControl(caster.hook_pfx, 3, Vector(1, 0, 0))

	caster:EmitSound("Hookshot.Launch")
	target:AddNewModifier(caster, ability, "modifier_keen_melee_ability_target", {})

	Timers:CreateTimer(hit_delay, function()
		target:EmitSound("Hookshot.Hit")
		target:RemoveModifierByName("modifier_keen_melee_ability_target")
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")})
		caster:AddNewModifier(caster, ability, "modifier_keen_melee_ability_dash", {target_index = target:entindex(), speed = speed})
		ProjectileManager:ProjectileDodge(caster)
	end)
	
	return nil
end



modifier_keen_melee_ability_target = class({})

function modifier_keen_melee_ability_target:IsHidden() return true end
function modifier_keen_melee_ability_target:IsDebuff() return false end
function modifier_keen_melee_ability_target:IsPurgable() return false end
function modifier_keen_melee_ability_target:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end



modifier_keen_melee_ability_dash = class({})

function modifier_keen_melee_ability_dash:IsDebuff() return false end
function modifier_keen_melee_ability_dash:IsHidden() return true end
function modifier_keen_melee_ability_dash:IsPurgable() return false end
function modifier_keen_melee_ability_dash:IsMotionController() return true end
function modifier_keen_melee_ability_dash:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST end

function modifier_keen_melee_ability_dash:OnCreated(keys)
	if IsServer() then
		self.target = EntIndexToHScript(keys.target_index)
		self.speed = keys.speed
		self:StartIntervalThink(0.03)
	end
end

function modifier_keen_melee_ability_dash:OnIntervalThink()
	if IsServer() then

		-- Move
		local parent = self:GetParent()
		local parent_loc = parent:GetAbsOrigin()
		local target_loc = self.target:GetAbsOrigin()
		local movement_tick = (target_loc - parent_loc):Normalized() * self.speed * 0.03
		GridNav:DestroyTreesAroundPoint(parent_loc, 128, false)
		parent:SetAbsOrigin(GetGroundPosition(parent_loc + movement_tick, parent))

		-- If the target has been reached, stop moving
		if (target_loc - parent_loc):Length2D() <= 128 then
			self:Destroy()
		end
	end
end

function modifier_keen_melee_ability_dash:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		ParticleManager:DestroyParticle(parent.hook_pfx, true)
		ParticleManager:ReleaseParticleIndex(parent.hook_pfx)
		parent:EmitSound("Hookshot.Damage")
		ApplyDamage({victim = self.target, attacker = parent, damage = self:GetAbility():GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL})
		Timers:CreateTimer(0.01, function()
			ResolveNPCPositions(parent:GetAbsOrigin(), 128)
		end)
	end
end



kingdom_keen_ranged_ability = class({})

function kingdom_keen_ranged_ability:GetIntrinsicModifierName()
	return "modifier_keen_ranged_ability"
end

LinkLuaModifier("modifier_keen_ranged_ability", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_keen_ranged_ability = class({})

function modifier_keen_ranged_ability:IsHidden() return true end
function modifier_keen_ranged_ability:IsDebuff() return false end
function modifier_keen_ranged_ability:IsPurgable() return false end
function modifier_keen_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_keen_ranged_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			local splash_radius = ability:GetSpecialValueFor("splash_radius")
			local target_loc = keys.target:GetAbsOrigin()

			local base_damage = 0.5 * (parent:GetBaseDamageMax() + parent:GetBaseDamageMin())
			local splash_damage = base_damage * ability:GetSpecialValueFor("damage") * 0.01

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			local blast_pfx = ParticleManager:CreateParticle("particles/shrapnel.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(blast_pfx, 0, target_loc)
			ParticleManager:ReleaseParticleIndex(blast_pfx)

			local enemies = FindUnitsInRadius(parent:GetTeamNumber(), target_loc, nil, splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if enemy ~= keys.target then
					ApplyDamage({victim = enemy, attacker = parent, damage = splash_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
				end
			end
		end
	end
end



kingdom_keen_cavalry_ability = class({})

function kingdom_keen_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_keen_cavalry_ability"
end

LinkLuaModifier("modifier_keen_cavalry_ability", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keen_cavalry_ability_effect", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_keen_cavalry_ability = class({})

function modifier_keen_cavalry_ability:IsHidden() return true end
function modifier_keen_cavalry_ability:IsDebuff() return false end
function modifier_keen_cavalry_ability:IsPurgable() return false end
function modifier_keen_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_keen_cavalry_ability:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			if parent:GetHealth() < parent:GetMaxHealth() * ability:GetSpecialValueFor("health_threshold") * 0.01 then
				parent:EmitSound("ChemicalRage.Start")
				parent:AddNewModifier(parent, ability, "modifier_keen_cavalry_ability_effect", {})
				self:Destroy()
			end
		end
	end
end



modifier_keen_cavalry_ability_effect = class({})

function modifier_keen_cavalry_ability_effect:IsHidden() return false end
function modifier_keen_cavalry_ability_effect:IsDebuff() return false end
function modifier_keen_cavalry_ability_effect:IsPurgable() return false end
function modifier_keen_cavalry_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_cavalry_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
	return funcs
end

function modifier_keen_cavalry_ability_effect:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_keen_cavalry_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_keen_cavalry_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_keen_cavalry_ability_effect:GetActivityTranslationModifiers()
	return "chemical_rage"
end

function modifier_keen_cavalry_ability_effect:GetAttackSound()
	return "Hero_Alchemist.ChemicalRage.Attack"
end

function modifier_keen_cavalry_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
end

function modifier_keen_cavalry_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_keen_cavalry_ability_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_chemical_rage.vpcf"
end

function modifier_keen_cavalry_ability_effect:StatusEffectPriority()
	return 10
end

function modifier_keen_cavalry_ability_effect:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_keen_cavalry_ability_effect:HeroEffectPriority()
	return 10
end



kingdom_keen_bounty_hunter_ability = class({})

function kingdom_keen_bounty_hunter_ability:GetIntrinsicModifierName()
	return "modifier_keen_bounty_hunter_ability"
end

LinkLuaModifier("modifier_keen_bounty_hunter_ability", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keen_bounty_hunter_ability_effect", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_keen_bounty_hunter_ability = class({})

function modifier_keen_bounty_hunter_ability:IsHidden() return true end
function modifier_keen_bounty_hunter_ability:IsDebuff() return false end
function modifier_keen_bounty_hunter_ability:IsPurgable() return false end
function modifier_keen_bounty_hunter_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_bounty_hunter_ability:IsAura()
	return true
end

function modifier_keen_bounty_hunter_ability:GetAuraRadius() return 1200 end
function modifier_keen_bounty_hunter_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_keen_bounty_hunter_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_keen_bounty_hunter_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_keen_bounty_hunter_ability:GetModifierAura() return "modifier_keen_bounty_hunter_ability_effect" end

modifier_keen_bounty_hunter_ability_effect = class({})

function modifier_keen_bounty_hunter_ability_effect:IsHidden() return true end
function modifier_keen_bounty_hunter_ability_effect:IsDebuff() return true end
function modifier_keen_bounty_hunter_ability_effect:IsPurgable() return false end
function modifier_keen_bounty_hunter_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_keen_bounty_hunter_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_keen_bounty_hunter_ability_effect:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local caster = self:GetAbility():GetCaster()
			local player = Kingdom:GetPlayerByTeam(caster:GetTeam())
			local player_id = Kingdom:GetPlayerID(player)
			local gold = self:GetAbility():GetSpecialValueFor("unit_gold")

			if keys.unit:HasModifier("modifier_kingdom_hero_marker") or keys.unit:HasModifier("modifier_kingdom_demon_hero_marker") then
				gold = self:GetAbility():GetSpecialValueFor("hero_gold")
			end

			PlayerResource:ModifyGold(player_id, gold, true, DOTA_ModifyGold_HeroKill)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, caster, gold, nil)
		end
	end
end



kingdom_keen_tinker_ability = class({})

function kingdom_keen_tinker_ability:GetIntrinsicModifierName()
	return "modifier_keen_tinker_ability"
end

LinkLuaModifier("modifier_keen_tinker_ability", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keen_tinker_ability_effect", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_keen_tinker_ability = class({})

function modifier_keen_tinker_ability:IsDebuff() return false end
function modifier_keen_tinker_ability:IsHidden() return true end
function modifier_keen_tinker_ability:IsPurgable() return false end
function modifier_keen_tinker_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_keen_tinker_ability:IsAura()
	return true
end

function modifier_keen_tinker_ability:GetAuraRadius() return 1200 end
function modifier_keen_tinker_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_keen_tinker_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_keen_tinker_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_keen_tinker_ability:GetModifierAura() return "modifier_keen_tinker_ability_effect" end

modifier_keen_tinker_ability_effect = class({})

function modifier_keen_tinker_ability_effect:IsHidden() return false end
function modifier_keen_tinker_ability_effect:IsDebuff() return false end
function modifier_keen_tinker_ability_effect:IsPurgable() return false end
function modifier_keen_tinker_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_keen_tinker_ability_effect:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()
		local health_multiplier = 1 + self:GetAbility():GetSpecialValueFor("bonus_health") * 0.01

		parent:SetBaseMaxHealth(base_health * health_multiplier)
		parent:SetMaxHealth(base_health * health_multiplier)
		parent:SetHealth(base_health * health_multiplier)
	end
end

function modifier_keen_tinker_ability_effect:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local base_health = parent:GetMaxHealth()
		local health_multiplier = 1 + self:GetAbility():GetSpecialValueFor("bonus_health") * 0.01

		parent:SetBaseMaxHealth(base_health / health_multiplier)
		parent:SetMaxHealth(base_health / health_multiplier)
		parent:SetHealth(base_health / health_multiplier)
	end
end



kingdom_keen_engineer_ability = class({})

function kingdom_keen_engineer_ability:GetIntrinsicModifierName()
	return "modifier_keen_engineer_ability"
end

LinkLuaModifier("modifier_keen_engineer_ability", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_keen_engineer_ability_effect", "kingdom/abilities/keen", LUA_MODIFIER_MOTION_NONE)

modifier_keen_engineer_ability = class({})

function modifier_keen_engineer_ability:IsDebuff() return false end
function modifier_keen_engineer_ability:IsHidden() return true end
function modifier_keen_engineer_ability:IsPurgable() return false end
function modifier_keen_engineer_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_keen_engineer_ability:IsAura()
	return true
end

function modifier_keen_engineer_ability:GetAuraRadius() return 1200 end
function modifier_keen_engineer_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_keen_engineer_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_keen_engineer_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_keen_engineer_ability:GetModifierAura() return "modifier_keen_engineer_ability_effect" end

modifier_keen_engineer_ability_effect = class({})

function modifier_keen_engineer_ability_effect:IsHidden() return false end
function modifier_keen_engineer_ability_effect:IsDebuff() return false end
function modifier_keen_engineer_ability_effect:IsPurgable() return false end
function modifier_keen_engineer_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_keen_engineer_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_keen_engineer_ability_effect:OnAttackLanded(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			ApplyDamage({victim = keys.attacker, attacker = keys.target, damage = self:GetAbility():GetSpecialValueFor("return_damage"), damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
end