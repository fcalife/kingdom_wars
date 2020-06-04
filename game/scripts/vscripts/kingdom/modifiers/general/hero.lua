--	Hero default state

modifier_kingdom_hero = class({})

function modifier_kingdom_hero:IsDebuff() return false end
function modifier_kingdom_hero:IsHidden() return true end
function modifier_kingdom_hero:IsPurgable() return false end
function modifier_kingdom_hero:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_hero:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local hero_abilities = {
			"kingdom_magic_attack",
			"kingdom_piercing_attack",
			"kingdom_normal_attack",
			"kingdom_no_armor",
			"kingdom_light_armor",
			"kingdom_heavy_armor",
			"kingdom_human_paladin_ability",
			"kingdom_human_mage_ability",
			"kingdom_human_commander_ability",
			"kingdom_elf_ranger_ability",
			"kingdom_elf_druid_ability",
			"kingdom_elf_assassin_ability",
			"kingdom_undead_necromancer_ability",
			"kingdom_undead_wraith_king_ability",
			"kingdom_undead_butcher_ability",
			"kingdom_keen_bounty_hunter_ability",
			"kingdom_keen_tinker_ability",
			"kingdom_keen_engineer_ability",
			"kingdom_orc_incursor_ability",
			"kingdom_orc_warlord_ability",
			"kingdom_orc_blademaster_ability",
			"kingdom_demon_nevermore_ability",
			"kingdom_demon_duchess_ability",
			"kingdom_demon_doom_ability"
		}

		for _, ability_name in pairs(hero_abilities) do
			local ability = parent:FindAbilityByName(ability_name)
			if ability then
				ability:SetLevel(1)
			end
		end

		parent:SetAbilityPoints(0)
	end
end

function modifier_kingdom_hero:CheckState()
	if self:GetParent():IsAlive() then
		return { [MODIFIER_STATE_NOT_ON_MINIMAP] = false }
	else
		return { [MODIFIER_STATE_NOT_ON_MINIMAP] = true	}
	end
end

function modifier_kingdom_hero:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_kingdom_hero:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			for index = 0, 8 do
				local item = keys.unit:GetItemInSlot(index)
				if item then
					CreateItemOnPositionForLaunch(keys.unit:GetAbsOrigin() + RandomVector(150), CreateItem(item:GetAbilityName(), nil, nil))
					item:Destroy()
				end
			end
		end
	end
end



modifier_kingdom_commander = class({})

function modifier_kingdom_commander:IsDebuff() return false end
function modifier_kingdom_commander:IsHidden() return true end
function modifier_kingdom_commander:IsPurgable() return false end
function modifier_kingdom_commander:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_commander:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local commander_abilities = {
			"kingdom_upgrade_to_capital",
			"kingdom_select_all_units",
			"kingdom_global_rally_point",
			"kingdom_ping_all_castles"
		}

		for _, ability_name in pairs(commander_abilities) do
			local ability = parent:FindAbilityByName(ability_name)
			if ability then
				ability:SetLevel(1)
			end
		end
	end
end

function modifier_kingdom_commander:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_EXP_RATE_BOOST
	}
	return funcs
end

function modifier_kingdom_commander:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_kingdom_commander:GetModifierPercentageExpRateBoost()
	return -100
end

function modifier_kingdom_commander:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return states
end



modifier_kingdom_hero_after_capital_selection = class({})

function modifier_kingdom_hero_after_capital_selection:IsDebuff() return false end
function modifier_kingdom_hero_after_capital_selection:IsHidden() return true end
function modifier_kingdom_hero_after_capital_selection:IsPurgable() return false end
function modifier_kingdom_hero_after_capital_selection:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_hero_after_capital_selection:OnCreated()
	if IsServer() then
		--self:GetParent():AddNoDraw()
	end
end

function modifier_kingdom_hero_after_capital_selection:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	return states
end