--	Orcish unit abilities

kingdom_buy_orc_melee = class({})

function kingdom_buy_orc_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_orc_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_orc_ranged = class({})

function kingdom_buy_orc_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_orc_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_orc_cavalry = class({})

function kingdom_buy_orc_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_orc_cavalry:GetGoldCost(level)
	return 5
end