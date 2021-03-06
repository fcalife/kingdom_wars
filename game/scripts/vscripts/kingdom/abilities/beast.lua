--	Beast unit abilities

kingdom_beast_1_ability = class({})

function kingdom_beast_1_ability:GetIntrinsicModifierName()
	return "modifier_beast_1_ability"
end


LinkLuaModifier("modifier_beast_1_ability", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

modifier_beast_1_ability = class({})

function modifier_beast_1_ability:IsHidden() return true end
function modifier_beast_1_ability:IsDebuff() return false end
function modifier_beast_1_ability:IsPurgable() return false end
function modifier_beast_1_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_1_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_beast_1_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			if ability:IsCooldownReady() then
				local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, ability:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
				if enemies[1] then
					local target = enemies[1]
					local origin_loc = parent:GetAbsOrigin()
					local target_loc = target:GetAbsOrigin()
					local final_loc = target_loc + (target_loc - origin_loc):Normalized() * 100

					local burrow_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(burrow_pfx, 0, origin_loc)
					ParticleManager:SetParticleControl(burrow_pfx, 1, target_loc)
					ParticleManager:ReleaseParticleIndex(burrow_pfx)

					parent:EmitSound("Ability.SandKing_BurrowStrike")
					ProjectileManager:ProjectileDodge(parent)
					FindClearSpaceForUnit(parent, final_loc, true)
					ResolveNPCPositions(final_loc, 128)
					ability:UseResources(true, false, true)

					local targets = FindUnitsInLine(parent:GetTeamNumber(), origin_loc, target_loc, nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for _, enemy in pairs(targets) do
						ApplyDamage({victim = enemy, attacker = parent, damage = ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL})

						local knockback = {
							center_x = origin_loc.x,
							center_y = origin_loc.y,
							center_z = origin_loc.z,
							duration = 0.4,
							knockback_duration = 0.4,
							knockback_distance = 40,
							knockback_height = 250
						}
					 
						enemy:RemoveModifierByName("modifier_knockback")
						enemy:AddNewModifier(enemy, nil, "modifier_knockback", knockback)

						local duration = ability:GetSpecialValueFor("stun_duration")
						if enemy:IsKingdomHero() then
							duration = duration * 0.5
						end
						enemy:AddNewModifier(parent, ability, "modifier_stunned", {duration = duration})
					end
				end
			end
		end
	end
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

			-- Proc!
			if RollPercentage(self:GetAbility():GetSpecialValueFor("proc_chance")) then

				ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = self:GetAbility():GetSpecialValueFor("proc_damage"), damage_type = DAMAGE_TYPE_PHYSICAL})

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
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end

function modifier_beast_3_ability:GetModifierHealthRegenPercentage()
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
LinkLuaModifier("modifier_beast_6_ability_buff", "kingdom/abilities/beast", LUA_MODIFIER_MOTION_NONE)

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
			keys.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_beast_6_ability_buff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		end
	end
end


modifier_beast_6_ability_effect = class({})

function modifier_beast_6_ability_effect:IsHidden() return false end
function modifier_beast_6_ability_effect:IsDebuff() return true end
function modifier_beast_6_ability_effect:IsPurgable() return true end
function modifier_beast_6_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_6_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_beast_6_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return (-1) * self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_beast_6_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return (-1) * self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_beast_6_ability_effect:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf"
end

function modifier_beast_6_ability_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_beast_6_ability_buff = class({})

function modifier_beast_6_ability_buff:IsHidden() return false end
function modifier_beast_6_ability_buff:IsDebuff() return false end
function modifier_beast_6_ability_buff:IsPurgable() return true end
function modifier_beast_6_ability_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_beast_6_ability_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_beast_6_ability_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_beast_6_ability_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_beast_6_ability_buff:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_corrosive_debuff.vpcf"
end

function modifier_beast_6_ability_buff:GetEffectAttachType()
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