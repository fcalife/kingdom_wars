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
		local player_color = Kingdom:GetKingdomPlayerColor(player)
		if PlayerResource:GetGold(player_id) >= gold_cost then
			PlayerResource:SpendGold(player_id, gold_cost, DOTA_ModifyGold_PurchaseItem)
			MapManager:UpgradeCity(region, city)
			EconomyManager:UpdateIncomeForPlayer(player)

			EmitSoundOnClient("ui.trophy_levelup", PlayerResource:GetPlayer(player_id))

			local flash_pfx = ParticleManager:CreateParticle("particles/city_upgrade_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(flash_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(flash_pfx)

			caster.upgrade_pfx = ParticleManager:CreateParticle("particles/upgraded_aura_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(caster.upgrade_pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 10))
			ParticleManager:SetParticleControl(caster.upgrade_pfx, 1, player_color)

			caster:RemoveAbility("kingdom_upgrade_city")
			caster:AddAbility("kingdom_upgraded_city"):SetLevel(1)

			EconomyManager:UpdateIncomeForPlayer(player)
		end
	end
end





kingdom_upgrade_to_capital = class({})

function kingdom_upgrade_to_capital:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if target:HasModifier("modifier_kingdom_city") then
		local region = target:GetRegion()
		local city = target:GetCity()
		local player = MapManager:GetCityOwner(region, city)
		local player_id = Kingdom:GetPlayerID(player)
		local player_color = Kingdom:GetKingdomPlayerColor(player)

		EmitSoundOnClient("General.FemaleLevelUp", PlayerResource:GetPlayer(player_id))

		local flash_pfx = ParticleManager:CreateParticle("particles/city_upgrade_capital.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(flash_pfx, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(flash_pfx)

		target.upgrade_pfx = ParticleManager:CreateParticle("particles/capital_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(target.upgrade_pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 10))
		ParticleManager:SetParticleControl(target.upgrade_pfx, 1, player_color)

		caster:AddNewModifier(caster, nil, "modifier_kingdom_hero_after_capital_selection", {})
		caster:RemoveAbility("kingdom_upgrade_to_capital")
		target:AddAbility("kingdom_capital"):SetLevel(1)

		EconomyManager:UpdateIncomeForPlayer(player)
	end
end





kingdom_capital = class({})

function kingdom_capital:GetIntrinsicModifierName()
	return "modifier_kingdom_capital"
end

LinkLuaModifier("modifier_kingdom_capital", "kingdom/abilities/cities", LUA_MODIFIER_MOTION_NONE)

modifier_kingdom_capital = class({})

function modifier_kingdom_capital:IsHidden() return true end
function modifier_kingdom_capital:IsDebuff() return false end
function modifier_kingdom_capital:IsPurgable() return false end
function modifier_kingdom_capital:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end




kingdom_upgraded_city = class({})

kingdom_rally_point = class({})

kingdom_portal_rally_point = class({})