-- Core initialization
if Kingdom == nil then
	_G.Kingdom = class({})
end

-- Other modules initialization
require('kingdom/map_manager')
require('kingdom/economy_manager')
require('kingdom/units')

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
	LinkLuaModifier("modifier_kingdom_hero", "kingdom/modifiers/general/hero", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_hero_marker", "kingdom/modifiers/general/unit_markers", LUA_MODIFIER_MOTION_NONE)

	-- Listeners
	--CustomGameEventManager:RegisterListener("mouse_position_think", Dynamic_Wrap(Kingdom, "MousePositionThink"))

	-- Globals
	KINGDOM_UNIT_TYPE_MELEE = 0
	KINGDOM_UNIT_TYPE_RANGED = 1
	KINGDOM_UNIT_TYPE_CAVALRY = 2
	KINGDOM_UNIT_TYPE_BEAST = 3

	--SendToConsole("dota_create_fake_clients")

	-- Set up proper player ids and teams
	self.player_ids = {}
	self.team_by_player = {}
	for id = 0, 40 do
		if PlayerResource:IsValidPlayer(id) then
			self.team_by_player[PlayerResource:GetTeam(id)] = #self.player_ids + 1
			self.player_ids[#self.player_ids + 1] = id
		end
	end

	local computer_team_order = {
		DOTA_TEAM_BADGUYS,
		DOTA_TEAM_CUSTOM_1,
		DOTA_TEAM_CUSTOM_2,
		DOTA_TEAM_CUSTOM_3,
		DOTA_TEAM_CUSTOM_4,
		DOTA_TEAM_CUSTOM_5,
		DOTA_TEAM_CUSTOM_6
	}
	local human_player_count = self:GetPlayerCount()
	if human_player_count < 8 then
		for player_number = (human_player_count + 1), 8 do
			self.player_ids[player_number] = player_number
			self.team_by_player[computer_team_order[player_number - 1]] = player_number
		end
	end

	-- Set up player colors
	for player_number, player_id in pairs(self:GetAllPlayerIDs()) do
		local color = self:GetKingdomPlayerColor(player_number)
		PlayerResource:SetCustomPlayerColor(player_id, color.x, color.y, color.z)
	end

	-- Initialize the territory manager
	MapManager:Init()

	-- Initialize the economy manager
	EconomyManager:Init()

	print("Kingdom core: finished initializing")

	local test_unit_table = {
		"npc_kingdom_hero_paladin",
		"npc_kingdom_hero_mage",
		"npc_kingdom_hero_commander",
		"npc_kingdom_hero_ranger",
		"npc_kingdom_hero_druid",
		"npc_kingdom_hero_assassin",
		"npc_kingdom_hero_necromancer",
		"npc_kingdom_hero_wraith_king",
		"npc_kingdom_hero_butcher",
		"npc_kingdom_hero_bounty_hunter",
		"npc_kingdom_hero_tinker",
		"npc_kingdom_hero_engineer",
		"npc_kingdom_hero_incursor",
		"npc_kingdom_hero_warlord",
		"npc_kingdom_hero_blademaster",
		"npc_kingdom_hero_nevermore",
		"npc_kingdom_hero_duchess",
		"npc_kingdom_hero_doom"
	}

	local x_test_offset = 800
	--for _, unit in pairs(test_unit_table) do
	--	CreateUnitByName(unit, Vector(x_test_offset, 1000, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	--	x_test_offset = x_test_offset + 175
	--end

	test_unit_table = {
		"npc_kingdom_human_melee",
		"npc_kingdom_elf_melee",
		"npc_kingdom_undead_melee",
		"npc_kingdom_keen_melee",
		"npc_kingdom_orc_melee",
		"npc_kingdom_demon_melee"
	}

	x_test_offset = 800
	--for _, unit in pairs(test_unit_table) do
	--	local unit_handle = CreateUnitByName(unit, Vector(x_test_offset, 600, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	--	unit_handle.type = KINGDOM_UNIT_TYPE_MELEE
	--	x_test_offset = x_test_offset + 175
	--end

	test_unit_table = {
		"npc_kingdom_human_ranged",
		"npc_kingdom_elf_ranged",
		"npc_kingdom_undead_ranged",
		"npc_kingdom_keen_ranged",
		"npc_kingdom_orc_ranged",
		"npc_kingdom_demon_ranged"
	}

	x_test_offset = 800
	--for _, unit in pairs(test_unit_table) do
	--	local unit_handle = CreateUnitByName(unit, Vector(x_test_offset, 900, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	--	unit_handle.type = KINGDOM_UNIT_TYPE_RANGED
	--	x_test_offset = x_test_offset + 175
	--end

	test_unit_table = {
		"npc_kingdom_human_cavalry",
		"npc_kingdom_elf_cavalry",
		"npc_kingdom_undead_cavalry",
		"npc_kingdom_keen_cavalry",
		"npc_kingdom_orc_cavalry",
		"npc_kingdom_demon_cavalry"
	}

	x_test_offset = 800
	--for _, unit in pairs(test_unit_table) do
	--	local unit_handle = CreateUnitByName(unit, Vector(x_test_offset, 1200, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	--	unit_handle.type = KINGDOM_UNIT_TYPE_CAVALRY
	--	x_test_offset = x_test_offset + 175
	--end
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
	return PLAYER_COLOR_LIST[player_number]
end

function Kingdom:GetPlayerByTeam(team)
	return self.team_by_player[team]
end

function Kingdom:GetKingdomPlayerTeam(player)
	return PlayerResource:GetTeam(self.player_ids[player])
end