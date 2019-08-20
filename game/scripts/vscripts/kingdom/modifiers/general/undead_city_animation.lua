--	Undead city animation

modifier_kingdom_undead_city_animation = class({})

function modifier_kingdom_undead_city_animation:IsDebuff() return false end
function modifier_kingdom_undead_city_animation:IsHidden() return true end
function modifier_kingdom_undead_city_animation:IsPurgable() return false end
function modifier_kingdom_undead_city_animation:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_undead_city_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
	return funcs
end

function modifier_kingdom_undead_city_animation:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_kingdom_undead_city_animation:GetOverrideAnimationRate()
	return 0.5
end