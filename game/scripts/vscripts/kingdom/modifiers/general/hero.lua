--	Hero default state

modifier_kingdom_hero = class({})

function modifier_kingdom_hero:IsDebuff() return false end
function modifier_kingdom_hero:IsHidden() return true end
function modifier_kingdom_hero:IsPurgable() return false end
function modifier_kingdom_hero:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_hero:OnCreated()
	if IsServer() then
		self:GetParent():AddNoDraw()
		self:GetParent():FindAbilityByName("kingdom_upgrade_to_capital"):SetLevel(1)
	end
end

function modifier_kingdom_hero:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
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
		self:GetParent():AddNoDraw()
	end
end

function modifier_kingdom_hero_after_capital_selection:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
	return states
end