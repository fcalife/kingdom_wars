--	City abilities

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
		local player = MapManager:GetCityOwner(region, city)
		local player_id = Kingdom:GetPlayerID(player)
		if PlayerResource:GetGold(player_id) >= gold_cost then
			self:UpgradeAbility(true)
			PlayerResource:SpendGold(player_id, gold_cost, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayer(player)
			MapManager:UpgradeCity(region, city)
			if self:GetLevel() >= 3 then
				self:SetActivated(false)
			end
		end
	end
end

kingdom_upgrade_portal = class({})

function kingdom_upgrade_portal:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager.demon_portals[caster.portal_number]["owner_player"])
	local gold_cost = self:GetGoldCost(self:GetLevel() - 1)
	PlayerResource:ModifyGold(player_id, gold_cost, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_upgrade_portal:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local gold_cost = self:GetGoldCost(self:GetLevel() - 1)
		local player = MapManager.demon_portals[caster.portal_number]["owner_player"]
		local player_id = Kingdom:GetPlayerID(player)

		if PlayerResource:GetGold(player_id) >= gold_cost then
			self:UpgradeAbility(true)
			PlayerResource:SpendGold(player_id, gold_cost, DOTA_ModifyGold_PurchaseItem)
			EconomyManager:UpdateIncomeForPlayer(player)
			MapManager:UpgradePortal(caster.portal_number)
			if self:GetLevel() >= 3 then
				self:SetActivated(false)
			end
		end
	end
end

kingdom_rally_point = class({})

function kingdom_rally_point:OnSpellStart()
end

kingdom_portal_rally_point = class({})

function kingdom_portal_rally_point:OnSpellStart()
end