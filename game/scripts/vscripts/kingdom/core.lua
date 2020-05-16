-- Core initialization
if Kingdom == nil then
	_G.Kingdom = class({})
end

-- Other modules initialization
require('kingdom/map_manager')
require('kingdom/economy_manager')
require('kingdom/units')
require('kingdom/voices')
require('kingdom/modifiers/general/region_markers')

-- Core kingdom functions
function Kingdom:Init()

	print("--- Kingdom core: initializing")

	-- Load KVs
	self.unit_stats = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- Universal modifiers
	LinkLuaModifier("modifier_kingdom_undead_city_animation", "kingdom/modifiers/general/undead_city_animation", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_keen_city_animation", "kingdom/modifiers/general/keen_city_animation", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_city", "kingdom/modifiers/general/city", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_city_pregame", "kingdom/modifiers/general/city", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_tower", "kingdom/modifiers/general/tower", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_capital_tower", "kingdom/modifiers/general/tower", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_tower_base", "kingdom/modifiers/general/tower", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero", "kingdom/modifiers/general/hero", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_commander", "kingdom/modifiers/general/hero", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero_after_capital_selection", "kingdom/modifiers/general/hero", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_unit_movement", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_beast_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_demon_hero_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_demon_spawn_leash", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)

	-- Listeners
	--CustomGameEventManager:RegisterListener("mouse_position_think", Dynamic_Wrap(Kingdom, "MousePositionThink"))

	-- Globals
	KINGDOM_UNIT_TYPE_MELEE = 0
	KINGDOM_UNIT_TYPE_RANGED = 1
	KINGDOM_UNIT_TYPE_CAVALRY = 2
	KINGDOM_UNIT_TYPE_BEAST = 3

	self.hero_cosmetics = {}
	self.hero_cosmetics["npc_dota_hero_legion_commander"] = {
		"models/heroes/legion_commander/legion_commander_arms.vmdl",
		"models/heroes/legion_commander/legion_commander_back.vmdl",
		"models/heroes/legion_commander/legion_commander_shoulders.vmdl",
		"models/heroes/legion_commander/legion_commander_head.vmdl",
		"models/heroes/legion_commander/legion_commander_weapon.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_paladin"] = {
		"models/heroes/omniknight/bracer.vmdl",
		"models/heroes/omniknight/cape.vmdl",
		"models/heroes/omniknight/hair.vmdl",
		"models/heroes/omniknight/hammer.vmdl",
		"models/heroes/omniknight/head.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_mage"] = {
		"models/heroes/crystal_maiden/crystal_maiden_cape.vmdl",
		"models/heroes/crystal_maiden/crystal_maiden_cuffs.vmdl",
		"models/heroes/crystal_maiden/crystal_maiden_shoulders.vmdl",
		"models/heroes/crystal_maiden/crystal_maiden_staff.vmdl",
		"models/heroes/crystal_maiden/head_item.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_commander"] = {
		"models/heroes/mars/mars_lower.vmdl",
		"models/heroes/mars/mars_shield.vmdl",
		"models/heroes/mars/mars_spear.vmdl",
		"models/heroes/mars/mars_upper.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_ranger"] = {
		"models/heroes/drow/drow_armor.vmdl",
		"models/heroes/drow/drow_bracer.vmdl",
		"models/heroes/drow/drow_cape.vmdl",
		"models/heroes/drow/drow_legs.vmdl",
		"models/heroes/drow/drow_quiver.vmdl",
		"models/heroes/drow/drow_haircowl.vmdl",
		"models/heroes/drow/drow_weapon.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_druid"] = {
		"models/heroes/furion/furion_beard.vmdl",
		"models/heroes/furion/furion_bracer.vmdl",
		"models/heroes/furion/furion_cape.vmdl",
		"models/heroes/furion/furion_horns.vmdl",
		"models/heroes/furion/furion_necklace.vmdl",
		"models/heroes/furion/furion_staff.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_assassin"] = {
		"models/heroes/phantom_assassin/phantom_assassin_cape.vmdl",
		"models/heroes/phantom_assassin/phantom_assassin_helmet.vmdl",
		"models/heroes/phantom_assassin/phantom_assassin_shoulders.vmdl",
		"models/heroes/phantom_assassin/phantom_assassin_weapon.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_necromancer"] = {
		"models/heroes/necrolyte/beard.vmdl",
		"models/heroes/necrolyte/hat.vmdl",
		"models/heroes/necrolyte/legs.vmdl",
		"models/heroes/necrolyte/shoulders.vmdl",
		"models/heroes/necrolyte/necrolyte_sickle.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_wraith_king"] = {
		"models/heroes/wraith_king/wraith_king_cape.vmdl",
		"models/heroes/wraith_king/wraith_king_chest.vmdl",
		"models/heroes/wraith_king/wraith_king_gauntlet.vmdl",
		"models/heroes/wraith_king/wraith_king_head.vmdl",
		"models/heroes/wraith_king/wraith_king_shoulder.vmdl",
		"models/heroes/wraith_king/wraith_king_weapon.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_butcher"] = {
		"models/heroes/pudge/back.vmdl",
		"models/heroes/pudge/belt.vmdl",
		"models/heroes/pudge/bracer.vmdl",
		"models/heroes/pudge/hair.vmdl",
		"models/heroes/pudge/leftarm.vmdl",
		"models/heroes/pudge/leftweapon.vmdl",
		"models/heroes/pudge/righthook.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_bounty_hunter"] = {
		"models/heroes/bounty_hunter/bounty_hunter_backpack.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_bandana.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_bweapon.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_lweapon.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_pads.vmdl",
		"models/heroes/bounty_hunter/bounty_hunter_rweapon.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_tinker"] = {
		"models/heroes/tinker/tinker_body_head.vmdl",
		"models/heroes/tinker/tinker_cape.vmdl",
		"models/heroes/tinker/tinker_helmet.vmdl",
		"models/heroes/tinker/tinker_left_arm.vmdl",
		"models/heroes/tinker/tinker_right_arm.vmdl",
		"models/heroes/tinker/tinker_shoulders.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_engineer"] = {
		"models/heroes/gyro/gyro_bottles.vmdl",
		"models/heroes/gyro/gyro_gloves.vmdl",
		"models/heroes/gyro/gyro_goggles.vmdl",
		"models/heroes/gyro/gyro_guns.vmdl",
		"models/heroes/gyro/gyro_head.vmdl",
		"models/heroes/gyro/gyro_missile.vmdl",
		"models/heroes/gyro/gyro_propeller.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_incursor"] = {
		"models/heroes/disruptor/back.vmdl",
		"models/heroes/disruptor/bracers.vmdl",
		"models/heroes/disruptor/weapon.vmdl",
		"models/heroes/disruptor/mount.vmdl",
		"models/heroes/disruptor/hair.vmdl",
		"models/heroes/disruptor/shoulder.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_warlord"] = {
		"models/heroes/elder_titan/elder_titan_bracer.vmdl",
		"models/heroes/elder_titan/elder_titan_hair.vmdl",
		"models/heroes/elder_titan/elder_titan_hammer.vmdl",
		"models/heroes/elder_titan/elder_titan_shoulder.vmdl",
		"models/heroes/elder_titan/elder_titan_totem.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_blademaster"] = {
		"models/heroes/juggernaut/jugg_bracers.vmdl",
		"models/heroes/juggernaut/jugg_cape.vmdl",
		"models/heroes/juggernaut/jugg_mask.vmdl",
		"models/heroes/juggernaut/jugg_sword.vmdl",
		"models/heroes/juggernaut/juggernaut_pants.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_nevermore"] = {
		"models/heroes/shadow_fiend/shadow_fiend_arms.vmdl",
		"models/heroes/shadow_fiend/shadow_fiend_head.vmdl",
		"models/heroes/shadow_fiend/shadow_fiend_shoulders.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_duchess"] = {
		"models/heroes/queenofpain/hair.vmdl",
		"models/heroes/queenofpain/queenofpain_weapon.vmdl",
		"models/heroes/queenofpain/shoulders.vmdl",
		"models/heroes/queenofpain/wings.vmdl"
	}
	self.hero_cosmetics["npc_kingdom_hero_doom"] = {
		"models/heroes/doom/belt.vmdl",
		"models/heroes/doom/bracer.vmdl",
		"models/heroes/doom/doom_helm.vmdl",
		"models/heroes/doom/doom_sword.vmdl",
		"models/heroes/doom/shoulders.vmdl",
		"models/heroes/doom/tail.vmdl",
		"models/heroes/doom/wings.vmdl"
	}

	-- Set up proper player ids, teams and colors
	self.player_ids = {}
	self.player_teams = {}
	self.player_by_team = {}
	self.player_colors = {}
	self.is_bot = {}
	self.bot_aggro = {}
	local current_player = 1
	for id = 0, 23 do
		if PlayerResource:IsValidPlayer(id) then

			print("player id "..id.." is kingdom player "..current_player)
			self.player_ids[current_player] = id
			self.player_teams[current_player] = PlayerResource:GetTeam(id)
			self.player_by_team[self.player_teams[current_player]] = current_player
			self.player_colors[current_player] = PLAYER_COLOR_LIST[self.player_teams[current_player]]
			self.is_bot[current_player] = false
			PlayerResource:SetCustomPlayerColor(id, self.player_colors[current_player].x, self.player_colors[current_player].y, self.player_colors[current_player].z)
			current_player = current_player + 1
		end
	end

	-- Add AI players
	local teams = {
		DOTA_TEAM_GOODGUYS,
		DOTA_TEAM_BADGUYS,
		DOTA_TEAM_CUSTOM_1,
		DOTA_TEAM_CUSTOM_2,
		DOTA_TEAM_CUSTOM_3,
		DOTA_TEAM_CUSTOM_4,
		DOTA_TEAM_CUSTOM_5,
		DOTA_TEAM_CUSTOM_6
	}

	local bot_names = {}
	bot_names[2] = "Alexander Bot"
	bot_names[3] = "Attila Bot"
	bot_names[4] = "Bonaparte Bot"
	bot_names[5] = "Caesar Bot"
	bot_names[6] = "Hannibal Bot"
	bot_names[7] = "Genghis Bot"
	bot_names[8] = "Leonidas Bot"

	for _, team in pairs(teams) do
		if PlayerResource:GetPlayerCountForTeam(team) < 1 then
			local hero = GameRules:AddBotPlayerWithEntityScript("npc_dota_hero_legion_commander", bot_names[current_player], team, "kingdom/bot_script.lua", true)
			hero:AddExperience(2000, DOTA_ModifyXP_HeroKill, false, true)
			local bot_id = hero:GetPlayerID()
			FindClearSpaceForUnit(hero, Vector(256 * (current_player - 4), 0, 0), true)
			self:InitializeBotCommander(hero)

			print("player id "..bot_id.." [BOT] is kingdom player "..current_player)

			self.player_ids[current_player] = bot_id
			self.player_teams[current_player] = team
			self.player_by_team[team] = current_player
			self.player_colors[current_player] = PLAYER_COLOR_LIST[team]
			self.is_bot[current_player] = true
			self.bot_aggro[current_player] = RandomInt(1, 75)

			PlayerResource:SetCustomPlayerColor(bot_id, self.player_colors[current_player].x, self.player_colors[current_player].y, self.player_colors[current_player].z)
			current_player = current_player + 1
		end
	end

	-- Initialize the territory manager
	MapManager:Init()

	-- Initialize the economy manager
	EconomyManager:Init()

	-- Initialize the unit voice system
	Voices:Init()

	print("Kingdom core: finished initializing")

end


-- Game start
function Kingdom:StartMatch()
	MapManager:StartCapitalPhase()
	EconomyManager:StartCapitalPhase()
end


-- Player information
function Kingdom:GetPlayerCount()
	return #self.player_ids
end

function Kingdom:GetPlayerID(player_number)
	return self.player_ids[player_number]
end

function Kingdom:GetAllPlayerIDs()
	return self.player_ids
end

function Kingdom:GetKingdomPlayerColor(player_number)
	return self.player_colors[player_number]
end

function Kingdom:GetPlayerByTeam(team)
	return self.player_by_team[team]
end

function Kingdom:GetKingdomPlayerTeam(player)
	return self.player_teams[player]
end

function Kingdom:IsBot(player)
	return self.is_bot[player]
end

function Kingdom:GetBotAggro(player)
	if self.bot_aggro[player] then
		return self.bot_aggro[player]
	else
		return 0
	end
end

function Kingdom:SetWinner(player)
	local player_id = Kingdom:GetPlayerID(player)
	GameRules:SetGameWinner(Kingdom:GetKingdomPlayerTeam(player))

	for _, id in pairs(Kingdom:GetAllPlayerIDs()) do
		if PlayerResource:GetPlayer(id) then
			ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/screen_arcane_drop.vpcf", PATTACH_EYES_FOLLOW, PlayerResource:GetSelectedHeroEntity(id), PlayerResource:GetPlayer(id))
		end
	end

	Timers:CreateTimer(0.5, function()
		local event = {}
		event.steamid = PlayerResource:GetSteamID(player_id)
		CustomGameEventManager:Send_ServerToAllClients("kingdom_winner", {event})
	end)
end

function Kingdom:GetDotaNameFromHeroName(hero_name)
	local hero_to_dota = {}

	hero_to_dota["npc_kingdom_hero_warlord"] = "npc_dota_hero_elder_titan"
	hero_to_dota["npc_kingdom_hero_engineer"] = "npc_dota_hero_gyrocopter"
	hero_to_dota["npc_kingdom_hero_wraith_king"] = "npc_dota_hero_skeleton_king"
	hero_to_dota["npc_kingdom_hero_incursor"] = "npc_dota_hero_disruptor"
	hero_to_dota["npc_kingdom_hero_bounty_hunter"] = "npc_dota_hero_bounty_hunter"
	hero_to_dota["npc_kingdom_hero_paladin"] = "npc_dota_hero_omniknight"
	hero_to_dota["npc_kingdom_hero_blademaster"] = "npc_dota_hero_juggernaut"
	hero_to_dota["npc_kingdom_hero_necromancer"] = "npc_dota_hero_necrolyte"
	hero_to_dota["npc_kingdom_hero_druid"] = "npc_dota_hero_furion"
	hero_to_dota["npc_kingdom_hero_butcher"] = "npc_dota_hero_pudge"
	hero_to_dota["npc_kingdom_hero_ranger"] = "npc_dota_hero_drow_ranger"
	hero_to_dota["npc_kingdom_hero_commander"] = "npc_dota_hero_mars"
	hero_to_dota["npc_kingdom_hero_assassin"] = "npc_dota_hero_phantom_assassin"
	hero_to_dota["npc_kingdom_hero_tinker"] = "npc_dota_hero_tinker"
	hero_to_dota["npc_kingdom_hero_mage"] = "npc_dota_hero_crystal_maiden"
	hero_to_dota["npc_kingdom_hero_duchess"] = "npc_dota_hero_queenofpain"
	hero_to_dota["npc_kingdom_hero_nevermore"] = "npc_dota_hero_nevermore"
	hero_to_dota["npc_kingdom_hero_doom"] = "npc_dota_hero_doom_bringer"

	return hero_to_dota[hero_name]
end

function Kingdom:InitializeBotCommander(hero_entity)
	local player_color = PLAYER_COLOR_LIST[hero_entity:GetTeam()]

	hero_entity:AddNewModifier(hero_entity, nil, "modifier_kingdom_hero", {})

	local children = hero_entity:GetChildren()
	for _, child in pairs(children) do
		if child:GetClassname() == "dota_item_wearable" then
			local model_name = child:GetModelName()
			child:Destroy()
		end
	end

	hero_entity:SetRenderColor(player_color.x, player_color.y, player_color.z)

	hero_entity.bracer = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/legion_commander/legion_commander_arms.vmdl"})
	hero_entity.bracer:FollowEntity(hero_entity, true)
	hero_entity.bracer:SetRenderColor(player_color.x, player_color.y, player_color.z)

	hero_entity.flag = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/legion_commander/legion_commander_back.vmdl"})
	hero_entity.flag:FollowEntity(hero_entity, true)
	hero_entity.flag:SetRenderColor(player_color.x, player_color.y, player_color.z)

	hero_entity.shoulder = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/legion_commander/legion_commander_shoulders.vmdl"})
	hero_entity.shoulder:FollowEntity(hero_entity, true)
	hero_entity.shoulder:SetRenderColor(player_color.x, player_color.y, player_color.z)

	hero_entity.helmet = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/legion_commander/legion_commander_head.vmdl"})
	hero_entity.helmet:FollowEntity(hero_entity, true)
	hero_entity.helmet:SetRenderColor(player_color.x, player_color.y, player_color.z)

	hero_entity.weapon = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/legion_commander/legion_commander_weapon.vmdl"})
	hero_entity.weapon:FollowEntity(hero_entity, true)
	hero_entity.weapon:SetRenderColor(player_color.x, player_color.y, player_color.z)
end