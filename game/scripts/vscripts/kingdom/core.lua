-- Core initialization
if Kingdom == nil then
	_G.Kingdom = class({})
end

-- Other modules initialization
--require('kingdom/citymanager')

-- Core kingdom functions
function Kingdom:Init()

	print("Initializing kingdom core...")

	-- Load KVs
	self.map_info = LoadKeyValues("scripts/npc/KV/map.kv")
	self.unit_stats = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- Universal modifiers
	--LinkLuaModifier("modifier_kingdom_modifier", "kingdom/modifiers/universal_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

	-- Listeners
	--CustomGameEventManager:RegisterListener("mouse_position_think", Dynamic_Wrap(Kingdom, "MousePositionThink"))

	-- Globals
	--SendToConsole("dota_create_fake_clients")

	-- Detect proper player ids
	self.player_ids = {}
	for id = 0, 40 do
		if PlayerResource:IsValidPlayer(id) then
			if PlayerResource:GetTeam(id) == DOTA_TEAM_GOODGUYS then
				self.player_ids[1] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_BADGUYS then
				self.player_ids[2] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_CUSTOM_1 then
				self.player_ids[3] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_CUSTOM_2 then
				self.player_ids[4] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_CUSTOM_3 then
				self.player_ids[5] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_CUSTOM_4 then
				self.player_ids[6] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_CUSTOM_5 then
				self.player_ids[7] = id
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_CUSTOM_6 then
				self.player_ids[8] = id
			end
		end
	end

	self.cities = {}



	-- Initialize the territory manager
	--MapManager:Init()

	-- Initialize the economy manager
	--EconomyManager:Init()
end