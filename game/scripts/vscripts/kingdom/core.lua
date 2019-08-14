-- Core initialization
if Kingdom == nil then
	_G.Kingdom = class({})
end

-- Other modules initialization
require('kingdom/map_manager')

-- Core kingdom functions
function Kingdom:Init()

	print("--- Kingdom core: initializing")

	-- Load KVs
	self.unit_stats = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- Universal modifiers
	--LinkLuaModifier("modifier_kingdom_modifier", "kingdom/modifiers/universal_modifiers.lua", LUA_MODIFIER_MOTION_NONE)

	-- Listeners
	--CustomGameEventManager:RegisterListener("mouse_position_think", Dynamic_Wrap(Kingdom, "MousePositionThink"))

	-- Globals
	--SendToConsole("dota_create_fake_clients")

	-- Set up proper player ids
	self.player_ids = {}
	for id = 0, 40 do
		if PlayerResource:IsValidPlayer(id) then
			self.player_ids[#self.player_ids + 1] = id
		end
	end

	if IsInToolsMode() then
		self.player_ids[2] = 2
		self.player_ids[3] = 3
		self.player_ids[4] = 4
		self.player_ids[5] = 5
		self.player_ids[6] = 6
		self.player_ids[7] = 7
		self.player_ids[8] = 8
	end

	-- Initialize the territory manager
	MapManager:Init()

	-- Initialize the economy manager
	--EconomyManager:Init()

	print("Kingdom core: finished initializing")
end

function Kingdom:GetPlayerCount()
	return #self.player_ids
end

function Kingdom:GetPlayerID(player_number)
	return self.player_ids[player_number]
end

function Kingdom:GetAllPlayerIDs()
	return self.player_ids
end