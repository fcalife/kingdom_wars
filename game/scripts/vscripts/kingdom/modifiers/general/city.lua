--	City default state

modifier_kingdom_city = class({})

function modifier_kingdom_city:IsDebuff() return false end
function modifier_kingdom_city:IsHidden() return true end
function modifier_kingdom_city:IsPurgable() return false end
function modifier_kingdom_city:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_city:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	return states
end

function modifier_kingdom_city:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
	return funcs
end

function modifier_kingdom_city:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_kingdom_city:GetModifierProvidesFOWVision()
	return 1
end





modifier_kingdom_city_pregame = class({})

function modifier_kingdom_city_pregame:IsDebuff() return false end
function modifier_kingdom_city_pregame:IsHidden() return true end
function modifier_kingdom_city_pregame:IsPurgable() return false end
function modifier_kingdom_city_pregame:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_city_pregame:CheckState()
	local states = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
	return states
end