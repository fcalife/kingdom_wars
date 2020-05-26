-- Riskwar: hero items

LinkLuaModifier("modifier_item_dagger", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dagger_crit", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_dagger = class({})

function item_dagger:GetIntrinsicModifierName()
	return "modifier_item_dagger"
end



modifier_item_dagger = class({})

function modifier_item_dagger:IsHidden() return true end
function modifier_item_dagger:IsDebuff() return false end
function modifier_item_dagger:IsPurgable() return false end
function modifier_item_dagger:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_dagger:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function modifier_item_dagger:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_item_dagger:OnAttackStart(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
			keys.attacker:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_dagger_crit", {})
		end
	end
end



modifier_item_dagger_crit = class({})

function modifier_item_dagger_crit:IsHidden() return true end
function modifier_item_dagger_crit:IsDebuff() return false end
function modifier_item_dagger_crit:IsPurgable() return false end
function modifier_item_dagger_crit:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_dagger_crit:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
	return funcs
end

function modifier_item_dagger_crit:GetModifierPreAttack_CriticalStrike()
	return self:GetAbility():GetSpecialValueFor("crit_damage")
end

function modifier_item_dagger_crit:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			self:Destroy()
		end
	end
end





LinkLuaModifier("modifier_item_hammer", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_hammer = class({})

function item_hammer:GetIntrinsicModifierName()
	return "modifier_item_hammer"
end



modifier_item_hammer = class({})

function modifier_item_hammer:IsHidden() return true end
function modifier_item_hammer:IsDebuff() return false end
function modifier_item_hammer:IsPurgable() return false end
function modifier_item_hammer:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_hammer:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_hammer:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then
			if keys.target:IsKingdomHero() then
				keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, keys.target, keys.target:GetMaxHealth(), nil)
				keys.target:Kill(self:GetAbility(), keys.attacker)
			end
		end
	end
end





LinkLuaModifier("modifier_item_god_creator", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_god_creator = class({})

function item_god_creator:GetIntrinsicModifierName()
	return "modifier_item_god_creator"
end



modifier_item_god_creator = class({})

function modifier_item_god_creator:IsHidden() return true end
function modifier_item_god_creator:IsDebuff() return false end
function modifier_item_god_creator:IsPurgable() return false end
function modifier_item_god_creator:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_god_creator:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_item_god_creator:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_god_creator:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and (not keys.unit:IsAlive()) then
			keys.attacker:Heal(keys.attacker:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("kill_restore") * 0.01, keys.attacker)
			
			local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
		end
	end
end





LinkLuaModifier("modifier_item_phantom_cape", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_phantom_cape = class({})

function item_phantom_cape:GetIntrinsicModifierName()
	return "modifier_item_phantom_cape"
end



modifier_item_phantom_cape = class({})

function modifier_item_phantom_cape:IsHidden() return true end
function modifier_item_phantom_cape:IsDebuff() return false end
function modifier_item_phantom_cape:IsPurgable() return false end
function modifier_item_phantom_cape:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_phantom_cape:GetEffectName()
	return "particles/items/phantom_cape.vpcf"
end

function modifier_item_phantom_cape:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantom_assassin_active_blur.vpcf"
end

function modifier_item_phantom_cape:StatusEffectPriority()
	return 10
end

function modifier_item_phantom_cape:CheckState()
	local states = {
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true
	}
	return states
end

function modifier_item_phantom_cape:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
	return funcs
end

function modifier_item_phantom_cape:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end





LinkLuaModifier("modifier_item_tarrasque_hide", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_tarrasque_hide = class({})

function item_tarrasque_hide:GetIntrinsicModifierName()
	return "modifier_item_tarrasque_hide"
end



modifier_item_tarrasque_hide = class({})

function modifier_item_tarrasque_hide:IsHidden() return true end
function modifier_item_tarrasque_hide:IsDebuff() return false end
function modifier_item_tarrasque_hide:IsPurgable() return false end
function modifier_item_tarrasque_hide:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_tarrasque_hide:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local max_health = parent:GetMaxHealth()
		local current_health = parent:GetHealth()
		local health_mult = 1 + 0.01 * self:GetAbility():GetSpecialValueFor("bonus_health")

		parent:SetBaseMaxHealth(max_health * health_mult)
		parent:SetMaxHealth(max_health * health_mult)
		parent:SetHealth(current_health * health_mult)
	end
end

function modifier_item_tarrasque_hide:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local max_health = parent:GetMaxHealth()
		local current_health = parent:GetHealth()
		local health_mult = 1 / (1 + 0.01 * self:GetAbility():GetSpecialValueFor("bonus_health"))

		parent:SetBaseMaxHealth(max_health * health_mult)
		parent:SetMaxHealth(max_health * health_mult)
		parent:SetHealth(current_health * health_mult)
	end
end

function modifier_item_tarrasque_hide:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_item_tarrasque_hide:OnTakeDamage(keys)
	if IsServer() then
		if self:GetParent() == keys.unit then
			if keys.attacker and keys.attacker:GetTeam() ~= keys.unit:GetTeam() then
				local damage = keys.damage * self:GetAbility():GetSpecialValueFor("damage_reflect") * 0.01
				ApplyDamage({attacker = keys.unit, victim = keys.attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION})
			end
		end
	end
end





LinkLuaModifier("modifier_item_dead_staff", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dead_staff_effect", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_dead_staff = class({})

function item_dead_staff:GetIntrinsicModifierName()
	return "modifier_item_dead_staff"
end



modifier_item_dead_staff = class({})

function modifier_item_dead_staff:IsHidden() return true end
function modifier_item_dead_staff:IsDebuff() return false end
function modifier_item_dead_staff:IsPurgable() return false end
function modifier_item_dead_staff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_dead_staff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_dead_staff:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_dead_staff_effect", {duration = self:GetAbility():GetSpecialValueFor("debuff_duration")})
		end
	end
end

modifier_item_dead_staff_effect = class({})

function modifier_item_dead_staff_effect:IsHidden() return false end
function modifier_item_dead_staff_effect:IsDebuff() return true end
function modifier_item_dead_staff_effect:IsPurgable() return false end
function modifier_item_dead_staff_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_dead_staff_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_item_dead_staff_effect:OnDeath(keys)
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
						ResolveNPCPositions(unit:GetAbsOrigin(), 128)
					end)
				end)
			end
		end
	end
end





LinkLuaModifier("modifier_item_eagle_boots", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_eagle_boots = class({})

function item_eagle_boots:GetIntrinsicModifierName()
	return "modifier_item_eagle_boots"
end



modifier_item_eagle_boots = class({})

function modifier_item_eagle_boots:IsHidden() return true end
function modifier_item_eagle_boots:IsDebuff() return false end
function modifier_item_eagle_boots:IsPurgable() return false end
function modifier_item_eagle_boots:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_eagle_boots:CheckState()
	local states = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return states
end

function modifier_item_eagle_boots:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_item_eagle_boots:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end





LinkLuaModifier("modifier_item_winter", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_winter_effect", "kingdom/items/items", LUA_MODIFIER_MOTION_NONE)

item_winter = class({})

function item_winter:GetIntrinsicModifierName()
	return "modifier_item_winter"
end



modifier_item_winter = class({})

function modifier_item_winter:IsHidden() return true end
function modifier_item_winter:IsDebuff() return false end
function modifier_item_winter:IsPurgable() return false end
function modifier_item_winter:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_winter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_item_winter:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() and RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then
			keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_winter_effect", {duration = self:GetAbility():GetSpecialValueFor("proc_duration")})
		end
	end
end

modifier_item_winter_effect = class({})

function modifier_item_winter_effect:IsHidden() return false end
function modifier_item_winter_effect:IsDebuff() return false end
function modifier_item_winter_effect:IsPurgable() return false end
function modifier_item_winter_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_item_winter_effect:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf"
end

function modifier_item_winter_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_winter_effect:CheckState()
	local states = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return states
end