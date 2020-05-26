--	Hero default state

modifier_kingdom_hero = class({})

function modifier_kingdom_hero:IsDebuff() return false end
function modifier_kingdom_hero:IsHidden() return true end
function modifier_kingdom_hero:IsPurgable() return false end
function modifier_kingdom_hero:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_kingdom_hero:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local hero_abilities = {
			"kingdom_magic_attack",
			"kingdom_piercing_attack",
			"kingdom_normal_attack",
			"kingdom_no_armor",
			"kingdom_light_armor",
			"kingdom_heavy_armor"
		}

		for _, ability_name in pairs(hero_abilities) do
			local ability = parent:FindAbilityByName(ability_name)
			if ability then
				ability:SetLevel(1)
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