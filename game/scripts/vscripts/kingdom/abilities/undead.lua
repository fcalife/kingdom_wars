--	Undead unit abilities

kingdom_buy_undead_melee = class({})

function kingdom_buy_undead_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_undead_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_undead_ranged = class({})

function kingdom_buy_undead_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_undead_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_undead_cavalry = class({})

function kingdom_buy_undead_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_undead_cavalry:GetGoldCost(level)
	return 5
end



kingdom_undead_melee_ability = class({})

function kingdom_undead_melee_ability:GetIntrinsicModifierName()
	return "modifier_undead_melee_ability"
end

LinkLuaModifier("modifier_undead_melee_ability", "kingdom/abilities/undead", LUA_MODIFIER_MOTION_NONE)

modifier_undead_melee_ability = class({})

function modifier_undead_melee_ability:IsHidden() return false end
function modifier_undead_melee_ability:IsDebuff() return false end
function modifier_undead_melee_ability:IsPurgable() return false end
function modifier_undead_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_undead_melee_ability:OnCreated(keys)
	if IsServer() then
		self.stacks = 0
		self:StartIntervalThink(1.0)
	end
end

function modifier_undead_melee_ability:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local zombies = 0
		local allies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			if ally:HasModifier("modifier_undead_melee_ability") then
				zombies = zombies + 1
			end
		end
		self:SetStackCount(zombies)
		if zombies ~= self.stacks then
			parent:SetBaseMaxHealth(350 * (1 + 0.05 * zombies))
			parent:SetMaxHealth(350 * (1 + 0.05 * zombies))
			parent:SetHealth(parent:GetHealth() * (1 + 0.05 * zombies) / (1 + 0.05 * self.stacks))
			self.stacks = zombies
		end
	end
end

function modifier_undead_melee_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_undead_melee_ability:GetModifierModelScale()
	return self:GetStackCount() * 3
end

function modifier_undead_melee_ability:OnTooltip()
	return self:GetStackCount() * 5
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