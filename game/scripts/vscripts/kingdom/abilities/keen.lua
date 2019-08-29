--	Keenfolk unit abilities

kingdom_buy_keen_melee = class({})

function kingdom_buy_keen_melee:OnSpellStart()
	ProductionManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_keen_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_keen_ranged = class({})

function kingdom_buy_keen_ranged:OnSpellStart()
	ProductionManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_keen_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_keen_cavalry = class({})

function kingdom_buy_keen_cavalry:OnSpellStart()
	ProductionManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_keen_cavalry:GetGoldCost(level)
	return 5
end