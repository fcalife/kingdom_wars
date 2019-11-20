--	Beast unit abilities

kingdom_beast_1_ability = class({})

function kingdom_beast_1_ability:GetIntrinsicModifierName()
	return "modifier_beast_1_ability"
end


LinkLuaModifier("modifier_beast_1_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beast_1_ability_effect", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_1_ability = class({})

function modifier_beast_1_ability:IsHidden() return true end
function modifier_beast_1_ability:IsDebuff() return false end
function modifier_beast_1_ability:IsPurgable() return false end
function modifier_beast_1_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_1_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_beast_1_ability:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			if parent:GetHealth() < parent:GetMaxHealth() * ability:GetSpecialValueFor("health_threshold") * 0.01 and ability:IsCooldownReady() then
				parent:EmitSound("Ability.SandKing_SandStorm.start")
				parent:AddNewModifier(parent, ability, "modifier_beast_1_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
				ProjectileManager:ProjectileDodge(parent)
				ability:UseResources(true, false, true)
			end
		end
	end
end


modifier_beast_1_ability_effect = class({})

function modifier_beast_1_ability_effect:IsHidden() return true end
function modifier_beast_1_ability_effect:IsDebuff() return false end
function modifier_beast_1_ability_effect:IsPurgable() return false end

function modifier_beast_1_ability_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1.0)
		self.sand_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self.sand_pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.sand_pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius")))
	end
end

function modifier_beast_1_ability_effect:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.sand_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.sand_pfx)
	end
end

function modifier_beast_1_ability_effect:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = parent, damage = ability:GetSpecialValueFor("dps"), damage_type = DAMAGE_TYPE_MAGICAL})
		end
	end
end

function modifier_beast_1_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_beast_1_ability_effect:CheckState()
	local states = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
	return states
end

function modifier_beast_1_ability_effect:GetModifierInvisibilityLevel()
	return 1.0
end

function modifier_beast_1_ability_effect:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end



kingdom_beast_2_ability = class({})

function kingdom_beast_2_ability:GetIntrinsicModifierName()
	return "modifier_beast_2_ability"
end


LinkLuaModifier("modifier_beast_2_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_2_ability = class({})

function modifier_beast_2_ability:IsHidden() return true end
function modifier_beast_2_ability:IsDebuff() return false end
function modifier_beast_2_ability:IsPurgable() return false end
function modifier_beast_2_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_2_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_beast_2_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			if RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then
				local duration = self:GetAbility():GetSpecialValueFor("proc_duration")
				if keys.target:IsKingdomHero() then
					duration = duration * 0.5
				end

				keys.target:EmitSound("Hero_Slardar.Bash")
				keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = duration})
			end
		end
	end
end



kingdom_beast_3_ability = class({})

function kingdom_beast_3_ability:GetIntrinsicModifierName()
	return "modifier_beast_3_ability"
end


LinkLuaModifier("modifier_beast_3_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_3_ability = class({})

function modifier_beast_3_ability:IsHidden() return true end
function modifier_beast_3_ability:IsDebuff() return false end
function modifier_beast_3_ability:IsPurgable() return false end
function modifier_beast_3_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_3_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return funcs
end

function modifier_beast_3_ability:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_regen")
end



kingdom_beast_4_ability = class({})

function kingdom_beast_4_ability:GetIntrinsicModifierName()
	return "modifier_beast_4_ability"
end


LinkLuaModifier("modifier_beast_4_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beast_4_ability_effect", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_4_ability = class({})

function modifier_beast_4_ability:IsHidden() return true end
function modifier_beast_4_ability:IsDebuff() return false end
function modifier_beast_4_ability:IsPurgable() return false end
function modifier_beast_4_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_4_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_beast_4_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			if not keys.target:HasModifier("modifier_beast_4_ability_effect") then
				keys.target:EmitSound("Item_Desolator.Target")
			end
			
			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_beast_4_ability_effect", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
	end
end


modifier_beast_4_ability_effect = class({})

function modifier_beast_4_ability_effect:IsHidden() return false end
function modifier_beast_4_ability_effect:IsDebuff() return true end
function modifier_beast_4_ability_effect:IsPurgable() return true end
function modifier_beast_4_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_4_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_beast_4_ability_effect:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction")
end



kingdom_beast_6_ability = class({})

function kingdom_beast_6_ability:GetIntrinsicModifierName()
	return "modifier_beast_6_ability"
end


LinkLuaModifier("modifier_beast_6_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beast_6_ability_effect", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_6_ability = class({})

function modifier_beast_6_ability:IsHidden() return true end
function modifier_beast_6_ability:IsDebuff() return false end
function modifier_beast_6_ability:IsPurgable() return false end
function modifier_beast_6_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_6_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_beast_6_ability:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_beast_6_ability_effect", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
	end
end


modifier_beast_6_ability_effect = class({})

function modifier_beast_6_ability_effect:IsHidden() return false end
function modifier_beast_6_ability_effect:IsDebuff() return true end
function modifier_beast_6_ability_effect:IsPurgable() return true end
function modifier_beast_6_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_6_ability_effect:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_beast_6_ability_effect:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local damage_tick = parent:GetMaxHealth() * 0.01 * ability:GetSpecialValueFor("damage") / ability:GetSpecialValueFor("duration")
		if parent:IsKingdomHero() then
			damage_tick = damage_tick * 0.5
		end

		ApplyDamage({victim = parent, attacker = self:GetCaster(), damage = damage_tick, damage_type = DAMAGE_TYPE_PURE})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, parent, damage_tick, nil)
	end
end

function modifier_beast_6_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_beast_6_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_beast_6_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_beast_6_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf"
end

function modifier_beast_6_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



kingdom_beast_7_ability = class({})

function kingdom_beast_7_ability:GetIntrinsicModifierName()
	return "modifier_beast_7_ability"
end


LinkLuaModifier("modifier_beast_7_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beast_7_ability_effect", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_7_ability = class({})

function modifier_beast_7_ability:IsHidden() return true end
function modifier_beast_7_ability:IsDebuff() return false end
function modifier_beast_7_ability:IsPurgable() return false end
function modifier_beast_7_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_7_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_beast_7_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then

			-- If broken, do nothing
			if self:GetParent():PassivesDisabled() or keys.target:IsKingdomHero() then
				return nil
			end

			if not keys.target:HasModifier("modifier_beast_7_ability_effect") then
				keys.target:EmitSound("Censure.Target")
			end

			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_beast_7_ability_effect", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
	end
end


modifier_beast_7_ability_effect = class({})

function modifier_beast_7_ability_effect:IsHidden() return false end
function modifier_beast_7_ability_effect:IsDebuff() return true end
function modifier_beast_7_ability_effect:IsPurgable() return true end
function modifier_beast_7_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_7_ability_effect:CheckState()
	local states = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
	return states
end

function modifier_beast_7_ability_effect:GetEffectName()
	return "particles/generic_gameplay/generic_muted.vpcf"
end

function modifier_beast_7_ability_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



kingdom_beast_8_ability = class({})

function kingdom_beast_8_ability:GetIntrinsicModifierName()
	return "modifier_beast_8_ability"
end



LinkLuaModifier("modifier_beast_8_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_beast_8_ability_effect", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_8_ability = class({})

function modifier_beast_8_ability:IsHidden() return true end
function modifier_beast_8_ability:IsDebuff() return false end
function modifier_beast_8_ability:IsPurgable() return false end
function modifier_beast_8_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_8_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_beast_8_ability:OnTakeDamage(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			if parent:GetHealth() < parent:GetMaxHealth() * ability:GetSpecialValueFor("health_threshold") * 0.01 and ability:IsCooldownReady() then
				parent:EmitSound("Hibernate.Start")
				parent:AddNewModifier(parent, ability, "modifier_beast_8_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
				ability:UseResources(true, false, true)
			end
		end
	end
end



modifier_beast_8_ability_effect = class({})

function modifier_beast_8_ability_effect:IsHidden() return false end
function modifier_beast_8_ability_effect:IsDebuff() return false end
function modifier_beast_8_ability_effect:IsPurgable() return false end
function modifier_beast_8_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_8_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end

function modifier_beast_8_ability_effect:CheckState()
	local states = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	return states
end

function modifier_beast_8_ability_effect:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_beast_8_ability_effect:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("regen")
end

function modifier_beast_8_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf"
end

function modifier_beast_8_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end