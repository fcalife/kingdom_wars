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