--	Undead unit abilities

kingdom_buy_undead_melee = class({})

function kingdom_buy_undead_melee:OnSpellStart()
	ProductionManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_undead_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_undead_ranged = class({})

function kingdom_buy_undead_ranged:OnSpellStart()
	ProductionManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_undead_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_undead_cavalry = class({})

function kingdom_buy_undead_cavalry:OnSpellStart()
	ProductionManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_undead_cavalry:GetGoldCost(level)
	return 5
end