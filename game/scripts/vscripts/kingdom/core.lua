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
	LinkLuaModifier("modifier_kingdom_undead_city_animation", "kingdom/modifiers/general/undead_city_animation", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_kingdom_keen_city_animation", "kingdom/modifiers/general/keen_city_animation", LUA_MODIFIER_MOTION_NONE)

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

	-- Set up player colors
	for player_number, player_id in pairs(self:GetAllPlayerIDs()) do
		local color = self:GetKingdomPlayerColor(player_number)
		PlayerResource:SetCustomPlayerColor(player_id, color.x, color.y, color.z)
	end

	-- Initialize the territory manager
	MapManager:Init()

	-- Initialize the economy manager
	--EconomyManager:Init()

	print("Kingdom core: finished initializing")
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