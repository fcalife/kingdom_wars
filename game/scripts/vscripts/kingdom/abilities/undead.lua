--	Undead unit abilities

kingdom_buy_undead_melee = class({})

function kingdom_buy_undead_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_undead_melee:GetGoldCost(level)
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



kingdom_buy_undead_ranged = class({})

function kingdom_buy_undead_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_undead_ranged:GetGoldCost(level)
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



kingdom_buy_undead_cavalry = class({})

function kingdom_buy_undead_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_undead_cavalry:GetGoldCost(level)
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



kingdom_buy_hero_necromancer = class({})

function kingdom_buy_hero_necromancer:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_necromancer:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(caster:GetRegion(), caster:GetCity())
			hero:EmitSound("Hero_Necrolyte.SpiritForm.Cast")
			hero:AddNewModifier(hero, self, "modifier_hero_necromancer_spawn_fx", {duration = 4})
		end
	end
end

function kingdom_buy_hero_necromancer:GetGoldCost(level)
	return 60
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
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_wraith_king:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(caster:GetRegion(), caster:GetCity())
			hero:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(2, 0, 0))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_wraith_king:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_butcher = class({})

function kingdom_buy_hero_butcher:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_butcher:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

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
	end
end

function kingdom_buy_hero_butcher:GetGoldCost(level)
	return 60
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

				Timers:CreateTimer(2, function()
					local unit = CreateUnitByName("npc_kingdom_undead_melee", self:GetParent():GetAbsOrigin(), true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
					unit:SetControllableByPlayer(player_id, true)

					Timers:CreateTimer(0.03, function()
						if not unit:HasModifier("modifier_undead_necromancer_ability_effect") then
							unit:SetHealth(unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("zombie_health") * 0.01)
						end
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
LinkLuaModifier("modifier_undead_ranged_ability_visual", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_ranged_ability = class({})

function modifier_undead_ranged_ability:IsHidden() return true end
function modifier_undead_ranged_ability:IsDebuff() return false end
function modifier_undead_ranged_ability:IsPurgable() return false end
function modifier_undead_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_undead_ranged_ability:OnDeath(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			-- Prevent loops
			if keys.unit:GetTeam() == self:GetParent():GetTeam() or keys.unit:HasModifier("modifier_undead_ranged_ability_visual") then
				return nil
			end

			local parent = self:GetParent()
			local original_unit = keys.unit
			local unit_name = original_unit:GetUnitName()
			local spawn_loc = original_unit:GetAbsOrigin()
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			local player_id = parent:GetOwnerEntity():GetPlayerID()
			local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
			local advanced_unit = false
			local elite_unit = false

			-- Does not work on undead
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
					return nil
				end
			end

			if parent:HasModifier("modifier_undead_necromancer_ability_effect") then
				duration = duration * 3
			end

			if original_unit:HasModifier("modifier_elite_unit") then
				advanced_unit = true
			end

			if original_unit:HasModifier("modifier_capital_unit") then
				elite_unit = true
			end

			Timers:CreateTimer(2, function()
				local flash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(flash_pfx, 0, spawn_loc)
				ParticleManager:SetParticleControl(flash_pfx, 1, spawn_loc)
				ParticleManager:ReleaseParticleIndex(flash_pfx)

				local new_unit = CreateUnitByName(unit_name, spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
				new_unit:SetControllableByPlayer(player_id, true)

				if elite_unit then
					new_unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
				elseif advanced_unit then
					new_unit:AddAbility("kingdom_elite_unit"):SetLevel(1)
				end

				new_unit:AddNewModifier(new_unit, nil, "modifier_kill", {duration = duration})
				new_unit:AddNewModifier(new_unit, nil, "modifier_undead_ranged_ability_visual", {})

				new_unit:EmitSound("BlackArrow.Raise")

				Timers:CreateTimer(0.1, function()
					ResolveNPCPositions(new_unit:GetAbsOrigin(), 128)
				end)
			end)
		end
	end
end

modifier_undead_ranged_ability_visual = class({})

function modifier_undead_ranged_ability_visual:IsHidden() return true end
function modifier_undead_ranged_ability_visual:IsDebuff() return false end
function modifier_undead_ranged_ability_visual:IsPurgable() return false end
function modifier_undead_ranged_ability_visual:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_ranged_ability_visual:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_undead_ranged_ability_visual:GetModifierTotalDamageOutgoing_Percentage()
	return -100
end

function modifier_undead_ranged_ability_visual:GetModifierIncomingDamage_Percentage()
	return 100
end

function modifier_undead_ranged_ability_visual:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf"
end

function modifier_undead_ranged_ability_visual:StatusEffectPriority()
	return 10
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

			-- If this is already a ressurected unit, do nothing
			if not self:GetAbility():IsActivated() then
				return nil
			end

			local parent = self:GetParent()
			local spawn_loc = parent:GetAbsOrigin()
			local return_health = self:GetAbility():GetSpecialValueFor("return_health")
			local player_id = parent:GetOwnerEntity():GetPlayerID()
			local player_hero = PlayerResource:GetSelectedHeroEntity(player_id)
			local necro_aura = false
			local advanced_unit = false
			local elite_unit = false

			if parent:HasModifier("modifier_undead_necromancer_ability_effect") then
				necro_aura = true
			end

			if parent:HasModifier("modifier_elite_unit") then
				advanced_unit = true
			end

			if parent:HasModifier("modifier_capital_unit") then
				elite_unit = true
			end

			Timers:CreateTimer(2, function()
				local return_pfx = ParticleManager:CreateParticle("particles/returned.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(return_pfx, 0, spawn_loc)
				ParticleManager:ReleaseParticleIndex(return_pfx)

				local new_unit = CreateUnitByName("npc_kingdom_undead_cavalry", spawn_loc, true, player_hero, player_hero, PlayerResource:GetTeam(player_id))
				new_unit:SetControllableByPlayer(player_id, true)

				if elite_unit then
					new_unit:AddAbility("kingdom_capital_unit"):SetLevel(1)
				elseif advanced_unit then
					new_unit:AddAbility("kingdom_elite_unit"):SetLevel(1)
				end

				if not necro_aura then
					new_unit:SetHealth(new_unit:GetMaxHealth() * return_health * 0.01)
				end

				new_unit:FindAbilityByName("kingdom_undead_cavalry_ability"):SetActivated(false)

				new_unit:EmitSound("BlackArrow.Raise")

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
function modifier_undead_necromancer_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_undead_necromancer_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_undead_necromancer_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_undead_necromancer_ability:GetModifierAura() return "modifier_undead_necromancer_ability_effect" end

modifier_undead_necromancer_ability_effect = class({})

function modifier_undead_necromancer_ability_effect:IsHidden() return true end
function modifier_undead_necromancer_ability_effect:IsDebuff() return false end
function modifier_undead_necromancer_ability_effect:IsPurgable() return false end
function modifier_undead_necromancer_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



kingdom_undead_wraith_king_ability = class({})

function kingdom_undead_wraith_king_ability:GetIntrinsicModifierName()
	return "modifier_undead_wraith_king_ability"
end

LinkLuaModifier("modifier_undead_wraith_king_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undead_wraith_king_ability_effect", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undead_wraith_king_ability_effect_delay", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_wraith_king_ability = class({})

function modifier_undead_wraith_king_ability:IsHidden() return true end
function modifier_undead_wraith_king_ability:IsDebuff() return false end
function modifier_undead_wraith_king_ability:IsPurgable() return false end
function modifier_undead_wraith_king_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_wraith_king_ability:IsAura()
	return true
end

function modifier_undead_wraith_king_ability:GetAuraRadius() return 1200 end
function modifier_undead_wraith_king_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_undead_wraith_king_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_undead_wraith_king_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_undead_wraith_king_ability:GetModifierAura() return "modifier_undead_wraith_king_ability_effect" end

modifier_undead_wraith_king_ability_effect = class({})

function modifier_undead_wraith_king_ability_effect:IsHidden() return true end
function modifier_undead_wraith_king_ability_effect:IsDebuff() return false end
function modifier_undead_wraith_king_ability_effect:IsPurgable() return false end
function modifier_undead_wraith_king_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_undead_wraith_king_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_undead_wraith_king_ability_effect:GetMinHealth()
	return 1
end

function modifier_undead_wraith_king_ability_effect:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			if keys.unit:GetHealth() < 2 then
				keys.unit:EmitSound("EternalFight.Wraith")
				keys.unit:AddNewModifier(keys.unit, nil, "modifier_undead_wraith_king_ability_effect_delay", {duration = self:GetAbility():GetSpecialValueFor("wraith_duration")})
			end
		end
	end
end

modifier_undead_wraith_king_ability_effect_delay = class({})

function modifier_undead_wraith_king_ability_effect_delay:IsHidden() return false end
function modifier_undead_wraith_king_ability_effect_delay:IsDebuff() return false end
function modifier_undead_wraith_king_ability_effect_delay:IsPurgable() return false end
function modifier_undead_wraith_king_ability_effect_delay:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_wraith_king_ability_effect_delay:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return states
end

function modifier_undead_wraith_king_ability_effect_delay:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_undead_wraith_king_ability_effect")
		self:GetParent():Kill(nil, self:GetParent())
	end
end

function modifier_undead_wraith_king_ability_effect_delay:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf"
end

function modifier_undead_wraith_king_ability_effect_delay:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_undead_wraith_king_ability_effect_delay:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function modifier_undead_wraith_king_ability_effect_delay:StatusEffectPriority()
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