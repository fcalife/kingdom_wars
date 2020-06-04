--	Human unit abilities

kingdom_buy_human_melee = class({})

function kingdom_buy_human_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_human_melee:GetGoldCost(level)
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



kingdom_buy_human_ranged = class({})

function kingdom_buy_human_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_human_ranged:GetGoldCost(level)
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



kingdom_buy_human_cavalry = class({})

function kingdom_buy_human_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
	EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(self:GetCaster(), self:GetGoldCost(0))
end

function kingdom_buy_human_cavalry:GetGoldCost(level)
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



kingdom_buy_hero_paladin = class({})

function kingdom_buy_hero_paladin:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_paladin:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Omniknight.Purification")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(256, 256, 256))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_paladin:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_mage = class({})

function kingdom_buy_hero_mage:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_mage:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_Crystal.CrystalNova")

			local spawn_pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 1, Vector(256, 0, 256))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_mage:GetGoldCost(level)
	return 60
end



kingdom_buy_hero_commander = class({})

function kingdom_buy_hero_commander:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	PlayerResource:ModifyGold(player_id, 60, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_buy_hero_commander:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= 60 then
			PlayerResource:SpendGold(player_id, 60, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, 60)

			local hero = EconomyManager:SpawnHero(region, city)

			hero:EmitSound("Hero_LegionCommander.Overwhelming.Location")

			local spawn_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(spawn_pfx, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(spawn_pfx, 4, Vector(256, 0, 0))
			ParticleManager:SetParticleControl(spawn_pfx, 5, Vector(256, 0, 0))
			ParticleManager:ReleaseParticleIndex(spawn_pfx)
		end
	end
end

function kingdom_buy_hero_commander:GetGoldCost(level)
	return 60
end



kingdom_human_melee_ability = class({})

function kingdom_human_melee_ability:GetIntrinsicModifierName()
	return "modifier_human_melee_ability"
end

LinkLuaModifier("modifier_human_melee_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_melee_ability = class({})

function modifier_human_melee_ability:IsHidden() return true end
function modifier_human_melee_ability:IsDebuff() return false end
function modifier_human_melee_ability:IsPurgable() return false end
function modifier_human_melee_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end



kingdom_human_ranged_ability = class({})

function kingdom_human_ranged_ability:GetIntrinsicModifierName()
	return "modifier_human_ranged_ability"
end

LinkLuaModifier("modifier_human_ranged_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_ranged_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_ranged_ability = class({})

function modifier_human_ranged_ability:IsHidden() return true end
function modifier_human_ranged_ability:IsDebuff() return false end
function modifier_human_ranged_ability:IsPurgable() return false end
function modifier_human_ranged_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_ranged_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function modifier_human_ranged_ability:OnAttackStart(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local parent = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if parent:PassivesDisabled() then
				return nil
			end

			if RollPercentage(ability:GetSpecialValueFor("proc_chance")) then
				parent:AddNewModifier(parent, ability, "modifier_human_ranged_ability_effect", {duration = ability:GetSpecialValueFor("duration")})
			end
		end
	end
end

modifier_human_ranged_ability_effect = class({})

function modifier_human_ranged_ability_effect:IsHidden() return false end
function modifier_human_ranged_ability_effect:IsDebuff() return false end
function modifier_human_ranged_ability_effect:IsPurgable() return false end
function modifier_human_ranged_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_ranged_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_human_ranged_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end



kingdom_human_cavalry_ability = class({})

function kingdom_human_cavalry_ability:GetIntrinsicModifierName()
	return "modifier_human_cavalry_ability"
end

LinkLuaModifier("modifier_human_cavalry_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_cavalry_ability_marker", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_cavalry_ability = class({})

function modifier_human_cavalry_ability:IsHidden() return true end
function modifier_human_cavalry_ability:IsDebuff() return false end
function modifier_human_cavalry_ability:IsPurgable() return false end
function modifier_human_cavalry_ability:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_cavalry_ability:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_ms"))
	end
end

function modifier_human_cavalry_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_human_cavalry_ability:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_human_cavalry_ability:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount() * 0.75
end

function modifier_human_cavalry_ability:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			local caster = self:GetParent()
			local ability = self:GetAbility()

			-- If broken, do nothing
			if caster:PassivesDisabled() then
				return nil
			end

			if ability:IsCooldownReady() then
				local duration = self:GetAbility():GetSpecialValueFor("stun_duration")
				if keys.target:IsKingdomHero() then
					duration = duration * 0.5
				end

				caster:AddNewModifier(caster, ability, "modifier_human_cavalry_ability_marker", {duration = 20})
				keys.target:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})

				self:SetStackCount(0)
				ability:UseResources(true, false, true)
			end
		end
	end
end

modifier_human_cavalry_ability_marker = class({})

function modifier_human_cavalry_ability_marker:IsHidden() return true end
function modifier_human_cavalry_ability_marker:IsDebuff() return false end
function modifier_human_cavalry_ability_marker:IsPurgable() return false end
function modifier_human_cavalry_ability_marker:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_human_cavalry_ability_marker:OnDestroy()
	if IsServer() then
		self:GetParent():FindModifierByName("modifier_human_cavalry_ability"):SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_ms"))
	end
end



kingdom_human_paladin_ability = class({})

function kingdom_human_paladin_ability:GetIntrinsicModifierName()
	return "modifier_human_paladin_ability"
end

LinkLuaModifier("modifier_human_paladin_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_paladin_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_paladin_ability = class({})

function modifier_human_paladin_ability:IsDebuff() return false end
function modifier_human_paladin_ability:IsHidden() return true end
function modifier_human_paladin_ability:IsPurgable() return false end
function modifier_human_paladin_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_human_paladin_ability:IsAura()
	return true
end

function modifier_human_paladin_ability:GetAuraRadius()
	if self:GetParent():HasModifier("modifier_item_horn") then
		return 2400
	else
		return 1200
	end
end

function modifier_human_paladin_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_human_paladin_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_human_paladin_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_human_paladin_ability:GetModifierAura() return "modifier_human_paladin_ability_effect" end

modifier_human_paladin_ability_effect = class({})

function modifier_human_paladin_ability_effect:IsHidden() return false end
function modifier_human_paladin_ability_effect:IsDebuff() return false end
function modifier_human_paladin_ability_effect:IsPurgable() return false end
function modifier_human_paladin_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_human_paladin_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	return funcs
end

function modifier_human_paladin_ability_effect:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("bonus_regen")
end



kingdom_human_mage_ability = class({})

function kingdom_human_mage_ability:GetIntrinsicModifierName()
	return "modifier_human_mage_ability"
end

LinkLuaModifier("modifier_human_mage_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_mage_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_mage_ability = class({})

function modifier_human_mage_ability:IsDebuff() return false end
function modifier_human_mage_ability:IsHidden() return true end
function modifier_human_mage_ability:IsPurgable() return false end
function modifier_human_mage_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_human_mage_ability:IsAura()
	return true
end

function modifier_human_mage_ability:GetAuraRadius()
	if self:GetParent():HasModifier("modifier_item_horn") then
		return 2400
	else
		return 1200
	end
end

function modifier_human_mage_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_human_mage_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_human_mage_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_human_mage_ability:GetModifierAura() return "modifier_human_mage_ability_effect" end

modifier_human_mage_ability_effect = class({})

function modifier_human_mage_ability_effect:IsHidden() return false end
function modifier_human_mage_ability_effect:IsDebuff() return true end
function modifier_human_mage_ability_effect:IsPurgable() return false end
function modifier_human_mage_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_human_mage_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_human_mage_ability_effect:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow_amount")
end

function modifier_human_mage_ability_effect:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow_amount")
end



kingdom_human_commander_ability = class({})

function kingdom_human_commander_ability:GetIntrinsicModifierName()
	return "modifier_human_commander_ability"
end

LinkLuaModifier("modifier_human_commander_ability", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_human_commander_ability_effect", "kingdom/abilities/human", LUA_MODIFIER_MOTION_NONE)

modifier_human_commander_ability = class({})

function modifier_human_commander_ability:IsDebuff() return false end
function modifier_human_commander_ability:IsHidden() return true end
function modifier_human_commander_ability:IsPurgable() return false end
function modifier_human_commander_ability:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_human_commander_ability:IsAura()
	return true
end

function modifier_human_commander_ability:GetAuraRadius()
	if self:GetParent():HasModifier("modifier_item_horn") then
		return 2400
	else
		return 1200
	end
end

function modifier_human_commander_ability:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_human_commander_ability:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_human_commander_ability:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_human_commander_ability:GetModifierAura() return "modifier_human_commander_ability_effect" end

modifier_human_commander_ability_effect = class({})

function modifier_human_commander_ability_effect:IsHidden() return false end
function modifier_human_commander_ability_effect:IsDebuff() return false end
function modifier_human_commander_ability_effect:IsPurgable() return false end
function modifier_human_commander_ability_effect:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_human_commander_ability_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_human_commander_ability_effect:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end