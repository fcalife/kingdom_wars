--	Human unit abilities

kingdom_buy_human_melee = class({})

function kingdom_buy_human_melee:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "melee")
end

function kingdom_buy_human_melee:GetGoldCost(level)
	return 3
end



kingdom_buy_human_ranged = class({})

function kingdom_buy_human_ranged:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "ranged")
end

function kingdom_buy_human_ranged:GetGoldCost(level)
	return 4
end



kingdom_buy_human_cavalry = class({})

function kingdom_buy_human_cavalry:OnSpellStart()
	EconomyManager:SpawnUnit(self:GetCaster():GetRegion(), self:GetCaster():GetCity(), "cavalry")
end

function kingdom_buy_human_cavalry:GetGoldCost(level)
	return 5
end