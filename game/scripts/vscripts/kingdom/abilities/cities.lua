--	City upgrade abilities

kingdom_upgrade_city = class({})

function kingdom_upgrade_city:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	local gold_cost = self:GetGoldCost(self:GetLevel() - 1)
	PlayerResource:ModifyGold(player_id, gold_cost, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_upgrade_city:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local gold_cost = self:GetGoldCost(self:GetLevel() - 1)
		local region = caster:GetRegion()
		local city = caster:GetCity()
		local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(region, city))
		if PlayerResource:GetGold(player_id) >= gold_cost then
			self:UpgradeAbility(true)
			PlayerResource:SpendGold(player_id, gold_cost, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayerDueToUnitPurchase(caster, gold_cost)
			MapManager:UpgradeCity(region, city)
			if self:GetLevel() >= 3 then
				self:SetActivated(false)
			end
		end
	end
end