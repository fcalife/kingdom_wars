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

	-- Listeners
	--CustomGameEventManager:RegisterListener("mouse_position_think", Dynamic_Wrap(Kingdom, "MousePositionThink"))

	-- Globals
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

	CreateUnitByName("npc_kingdom_demon_melee", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_melee", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_melee", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_melee", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_ranged", Vector(500, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_ranged", Vector(500, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_ranged", Vector(500, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_ranged", Vector(500, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_cavalry", Vector(1000, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_cavalry", Vector(1000, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_cavalry", Vector(1000, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	CreateUnitByName("npc_kingdom_demon_cavalry", Vector(1000, 0, 0), true, nil, nil, DOTA_TEAM_CUSTOM_3)
	Timers:CreateTimer(0.1, function()
		ResolveNPCPositions(Vector(0, 0, 0), 500)
		ResolveNPCPositions(Vector(500, 0, 0), 500)
		ResolveNPCPositions(Vector(1000, 0, 0), 500)
	end)
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