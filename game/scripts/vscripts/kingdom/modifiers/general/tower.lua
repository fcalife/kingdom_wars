--	Tower default state

modifier_kingdom_tower = class({})

function modifier_kingdom_tower:IsDebuff() return false end
function modifier_kingdom_tower:IsHidden() return true end
function modifier_kingdom_tower:IsPurgable() return false end
function modifier_kingdom_tower:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_kingdom_tower:OnCreated()
	if IsServer() then
		self.as_bonus = {0, 0, 100}
		self.dmg_pct = {0.55, 1.0, 1.0}
	end
end

function modifier_kingdom_tower:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
	return states
end

function modifier_kingdom_tower:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_kingdom_tower:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self:GetParent() then
			ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = keys.target:GetMaxHealth() * self.dmg_pct[self:GetParent():GetLevel()], damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function modifier_kingdom_tower:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return self.as_bonus[self:GetParent():GetLevel()]
	end
end