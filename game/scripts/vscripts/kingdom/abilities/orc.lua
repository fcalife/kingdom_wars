--	Orcish unit abilities

kingdom_buy_orc_melee = class({})

function kingdom_buy_orc_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_orc_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_orc_ranged = class({})

function kingdom_buy_orc_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_orc_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_orc_cavalry = class({})

function kingdom_buy_orc_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_orc_cavalry:GetGoldCost(level)
	return 5
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