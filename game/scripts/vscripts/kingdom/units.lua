-- Unit-based Kingdom Wars functions

function CDOTA_BaseNPC:GetRegion()
	return self.region
end

function CDOTA_BaseNPC:GetCity()
	return self.city
end

function CDOTA_BaseNPC:IsKingdomHero()
	if self:HasModifier("modifier_kingdom_hero_marker") or self:HasModifier("modifier_kingdom_demon_hero_marker") then
		return true
	else
		return false
	end
end