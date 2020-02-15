--	City abilities

kingdom_upgrade_city_2 = class({})

function kingdom_upgrade_city_2:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	local gold_cost = self:GetGoldCost(self:GetLevel() - 1)
	PlayerResource:ModifyGold(player_id, gold_cost, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_upgrade_city_2:GetGoldCost(level)
	local caster = self:GetCaster()
	local gold_cost = self:GetSpecialValueFor("upgrade_cost")

	if caster:HasModifier("modifier_kingdom_r5_contender") then
		gold_cost = gold_cost * 0.5
	end

	return gold_cost
end

function kingdom_upgrade_city_2:OnChannelFinish(interrupted)
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

			EmitSoundOnClient("ui.trophy_levelup", PlayerResource:GetPlayer(player_id))

			local flash_pfx = ParticleManager:CreateParticle("particles/city_upgrade_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(flash_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(flash_pfx)

			caster.level_2_pfx = ParticleManager:CreateParticle("particles/upgraded_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(caster.level_2_pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 10))
			ParticleManager:SetParticleControl(caster.level_2_pfx, 1, player_color)

			caster:RemoveAbility("kingdom_city_1")
			caster:AddAbility("kingdom_city_2"):SetLevel(1)

			caster:RemoveAbility("kingdom_upgrade_city_2")
			local next_ability = caster:AddAbility("kingdom_upgrade_city_3")
			next_ability:SetLevel(1)

			if not MapManager:IsCapital(region, city) then
				next_ability:SetActivated(false)
			end

			EconomyManager:UpdateIncomeForPlayer(player)
		end
	end
end





kingdom_upgrade_city_3 = class({})

function kingdom_upgrade_city_3:OnSpellStart()
	local caster = self:GetCaster()
	local player_id = Kingdom:GetPlayerID(MapManager:GetCityOwner(caster:GetRegion(), caster:GetCity()))
	local gold_cost = self:GetGoldCost(self:GetLevel() - 1)
	PlayerResource:ModifyGold(player_id, gold_cost, true, DOTA_ModifyGold_HeroKill)
end

function kingdom_upgrade_city_3:GetGoldCost(level)
	local caster = self:GetCaster()
	local gold_cost = self:GetSpecialValueFor("upgrade_cost")

	if caster:HasModifier("modifier_kingdom_r5_contender") then
		gold_cost = gold_cost * 0.5
	end

	return gold_cost
end

function kingdom_upgrade_city_3:OnChannelFinish(interrupted)
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

			EmitSoundOnClient("ui.badge_levelup", PlayerResource:GetPlayer(player_id))

			ParticleManager:DestroyParticle(caster.level_2_pfx, false)
			ParticleManager:ReleaseParticleIndex(caster.level_2_pfx)

			local flash_pfx = ParticleManager:CreateParticle("particles/city_upgrade_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(flash_pfx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(flash_pfx)

			caster.level_3_pfx = ParticleManager:CreateParticle("particles/upgraded_aura_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(caster.level_3_pfx, 0, caster:GetAbsOrigin() + Vector(0, 0, 10))
			ParticleManager:SetParticleControl(caster.level_3_pfx, 1, player_color)

			caster:RemoveAbility("kingdom_city_2")
			caster:AddAbility("kingdom_city_3"):SetLevel(1)

			caster:RemoveAbility("kingdom_upgrade_city_3")

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
		local target_loc = target:GetAbsOrigin()

		EmitSoundOnClient("General.FemaleLevelUp", PlayerResource:GetPlayer(player_id))

		local flash_pfx = ParticleManager:CreateParticle("particles/city_upgrade_capital.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(flash_pfx, 0, target_loc)
		ParticleManager:ReleaseParticleIndex(flash_pfx)

		target:Destroy()
		MapManager:SpawnCapital(region, city)
		target = MapManager:GetCityByNumber(region, city)
		MapManager:SetCityControllable(region, city, player)

		target.capital_pfx = ParticleManager:CreateParticle("particles/capital_aura.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(target.capital_pfx, 0, target_loc + Vector(0, 0, 10))
		ParticleManager:SetParticleControl(target.capital_pfx, 1, player_color)

		caster:AddNewModifier(caster, nil, "modifier_kingdom_hero_after_capital_selection", {})
		caster:RemoveAbility("kingdom_upgrade_to_capital")
		target:AddAbility("kingdom_capital"):SetLevel(1)

		MapManager:UpgradeCapitalTower(region, city)

		EconomyManager:UpdateIncomeForPlayer(player)

		local event = {}
		event.playerid = player_id
		event.playername = PlayerResource:GetPlayerName(player_id)
		event.steamid = PlayerResource:GetSteamID(player_id)
		event.cityname = "#npc_kingdom_city_"..region.."_"..city

		CustomGameEventManager:Send_ServerToAllClients("kingdom_capital_chosen", {event})
		CustomGameEventManager:Send_ServerToAllClients("kingdom_minimap_ping", {x = target_loc.x, y = target_loc.y, z = target_loc.z + 10})
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




kingdom_city_1 = class({})

kingdom_city_2 = class({})

kingdom_city_3 = class({})

kingdom_city_portal = class({})

kingdom_rally_point = class({})

kingdom_portal_rally_point = class({})