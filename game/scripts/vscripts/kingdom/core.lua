-- Core initialization
if Kingdom == nil then
	_G.Kingdom = class({})
end

-- Other modules initialization
require('kingdom/map_manager')
require('kingdom/economy_manager')
require('kingdom/units')
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
	LinkLuaModifier("modifier_kingdom_tower", "kingdom/modifiers/general/tower", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_tower_base", "kingdom/modifiers/general/tower", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero", "kingdom/modifiers/general/hero", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero_after_capital_selection", "kingdom/modifiers/general/hero", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_unit_movement", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_beast_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_demon_hero_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)

	-- Listeners
	--CustomGameEventManager:RegisterListener("mouse_position_think", Dynamic_Wrap(Kingdom, "MousePositionThink"))

	-- Globals
	KINGDOM_UNIT_TYPE_MELEE = 0
	KINGDOM_UNIT_TYPE_RANGED = 1
	KINGDOM_UNIT_TYPE_CAVALRY = 2
	KINGDOM_UNIT_TYPE_BEAST = 3

	-- Set up proper player ids, teams and colors
	self.player_ids = {}
	self.player_teams = {}
	self.player_by_team = {}
	self.player_colors = {}
	local current_player = 1
	for id = 0, 40 do
		if PlayerResource:IsValidPlayer(id) then

			print("player id "..id.." is kingdom player "..current_player)
			self.player_ids[current_player] = id
			self.player_teams[current_player] = PlayerResource:GetTeam(id)
			self.player_by_team[self.player_teams[current_player]] = current_player
			self.player_colors[current_player] = PLAYER_COLOR_LIST[self.player_teams[current_player]]
			PlayerResource:SetCustomPlayerColor(id, self.player_colors[current_player].x, self.player_colors[current_player].y, self.player_colors[current_player].z)
			current_player = current_player + 1
		end
	end

	-- Initialize the territory manager
	MapManager:Init()

	-- Initialize the economy manager
	EconomyManager:Init()

	print("Kingdom core: finished initializing")

end


-- Game start
function Kingdom:StartMatch()
	MapManager:StartMatch()
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
	hero_to_dota["npc_kingdom_hero_commander"] = "npc_dota_hero_legion_commander"
	hero_to_dota["npc_kingdom_hero_assassin"] = "npc_dota_hero_phantom_assassin"
	hero_to_dota["npc_kingdom_hero_tinker"] = "npc_dota_hero_tinker"
	hero_to_dota["npc_kingdom_hero_mage"] = "npc_dota_hero_crystal_maiden"
	hero_to_dota["npc_kingdom_hero_duchess"] = "npc_dota_hero_queenofpain"
	hero_to_dota["npc_kingdom_hero_nevermore"] = "npc_dota_hero_nevermore"
	hero_to_dota["npc_kingdom_hero_doom"] = "npc_dota_hero_doom_bringer"

	return hero_to_dota[hero_name]
end