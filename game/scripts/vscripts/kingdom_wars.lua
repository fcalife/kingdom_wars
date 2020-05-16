-- Barebones-based initialization
BAREBONES_VERSION = "1.00"

if GameMode == nil then
	print("Initializing game mode...")
	_G.GameMode = class({})
end

function GameMode:PostLoadPrecache()
	print("Performing post-load precache...")    
	--PrecacheItemByNameAsync("item_example_item", function(...) end)
	--PrecacheItemByNameAsync("example_ability", function(...) end)
	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
end

function GameMode:OnFirstPlayerLoaded()
	print("First player has finished loading the gamemode")
end

function GameMode:OnAllPlayersLoaded()
	print("All players have finished loading the gamemode")
end

function GameMode:OnHeroInGame(hero)
	print(hero:GetUnitName() .. " spawned in game for the first time.")
end

function GameMode:OnGameInProgress()
	if IsServer() then
		print("The game has officially begun")
	end
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	print("Performing initialization tasks...")

	-- Global filter setup
	--GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldFilter"), self)
	--GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(GameMode, "ExpFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
	--GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierFilter"), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "OrderFilter"), self)

	-- Custom console commands
	--Convars:RegisterCommand("runes_on", Dynamic_Wrap(GameMode, 'EnableAllRunes'), "Enables all runes", FCVAR_CHEAT )
	--Convars:RegisterCommand("runes_off", Dynamic_Wrap(GameMode, 'DisableAllRunes'), "Disables all runes", FCVAR_CHEAT )

	-- Custom listeners
	CustomGameEventManager:RegisterListener("increase_game_speed", Dynamic_Wrap(GameMode, "IncreaseGameSpeed"))

	print("Initialization tasks done!")
end

-- Game speed change function
function GameMode:IncreaseGameSpeed(keys)
	--GAME_SPEED_MULTIPLIER = keys.speed * 0.01
end

-- Global gold filter function
function GameMode:GoldFilter(keys)
	--keys.gold = keys.gold * GAME_SPEED_MULTIPLIER
	return true
end

-- Global experience filter function
function GameMode:ExpFilter(keys)
	--keys.experience: 40
	--keys.player_id_const: 1
	--keys.hero_entindex_const: 
	--keys.reason_const: 1
	--keys.experience = keys.experience * GAME_SPEED_MULTIPLIER

	--local hero = PlayerResource:GetSelectedHeroEntity(keys.player_id_const)

	return true
end

-- Global damage filter function
function GameMode:DamageFilter(keys)
	-- keys.damage: 5
	-- keys.damagetype_const: 1
	-- keys.entindex_inflictor_const: 801	--optional
	-- keys.entindex_attacker_const: 172
	-- keys.entindex_victim_const: 379

	local attacker = EntIndexToHScript(keys.entindex_attacker_const)
	local victim = EntIndexToHScript(keys.entindex_victim_const)

	if attacker and victim then
		if attacker:HasModifier("modifier_normal_attack") then
			if victim:HasModifier("modifier_light_armor") then
				keys.damage = keys.damage * 1.5
			elseif victim:HasModifier("kingdom_heavy_armor") then
				keys.damage = keys.damage * 0.75
			end
		end

		if attacker:HasModifier("modifier_piercing_attack") then
			if victim:HasModifier("modifier_no_armor") then
				keys.damage = keys.damage * 1.5
			elseif victim:HasModifier("kingdom_heavy_armor") then
				keys.damage = keys.damage * 0.75
			end

			if victim:HasModifier("modifier_human_melee_ability") then
				keys.damage = keys.damage * 0.5
			end
		end
	end

	return true
end

-- Global modifier filter function
function GameMode:ModifierFilter(keys)
	--keys.duration: -1
	--keys.entindex_ability_const: 164	--optional
	--keys.entindex_caster_const: 163
	--keys.entindex_parent_const: 163
	--keys.name_const: modifier_kobold_taskmaster_speed_aura

	--local victim = EntIndexToHScript(keys.entindex_parent_const)

	return true
end

-- Global order filter function
function GameMode:OrderFilter(keys)

	-- keys.entindex_ability	 ==> 	0
	-- keys.sequence_number_const	 ==> 	20
	-- keys.queue	 ==> 	0
	-- keys.units	 ==> 	table: 0x031d5fd0
	-- keys.entindex_target	 ==> 	0
	-- keys.position_z	 ==> 	384
	-- keys.position_x	 ==> 	-5694.3334960938
	-- keys.order_type	 ==> 	1
	-- keys.position_y	 ==> 	-6381.1127929688
	-- keys.issuer_player_id_const	 ==> 	0

	local order_type = keys.order_type
	
	-- Rally point logic
	if keys.entindex_ability then
		local ability = EntIndexToHScript(keys.entindex_ability)
		if ability and ability.GetAbilityName then
			if ability:GetAbilityName() == "kingdom_rally_point" then
				local caster = ability:GetCaster()
				local target_loc = Vector(keys.position_x, keys.position_y, keys.position_z)

				MapManager:SetRallyPoint(caster.region, caster.city, target_loc)

				EmitSoundOnLocationWithCaster(target_loc, "General.PingAttack", caster)

				local ping_pfx = ParticleManager:CreateParticleForTeam("particles/ui_mouseactions/ping_waypoint.vpcf", PATTACH_CUSTOMORIGIN, nil, caster:GetTeam())
				ParticleManager:SetParticleControl(ping_pfx, 0, target_loc)
				ParticleManager:SetParticleControl(ping_pfx, 5, Vector(3, 0, 0))
				ParticleManager:SetParticleControl(ping_pfx, 7, Vector(255, 0, 0))
				ParticleManager:ReleaseParticleIndex(ping_pfx)

				return false
			elseif ability:GetAbilityName() == "kingdom_portal_rally_point" then
				local caster = ability:GetCaster()
				local target_loc = Vector(keys.position_x, keys.position_y, keys.position_z)

				MapManager:SetPortalRallyPoint(caster.portal_number, target_loc)

				EmitSoundOnLocationWithCaster(target_loc, "General.PingAttack", caster)

				local ping_pfx = ParticleManager:CreateParticleForTeam("particles/ui_mouseactions/ping_waypoint.vpcf", PATTACH_CUSTOMORIGIN, nil, caster:GetTeam())
				ParticleManager:SetParticleControl(ping_pfx, 0, target_loc)
				ParticleManager:SetParticleControl(ping_pfx, 5, Vector(3, 0, 0))
				ParticleManager:SetParticleControl(ping_pfx, 7, Vector(255, 0, 0))
				ParticleManager:ReleaseParticleIndex(ping_pfx)

				return false
			end
		end
	end

	-- Voicelines
	if keys.units["0"] and keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		local unit = EntIndexToHScript(keys.units["0"])
		Voices:PlayLine(VOICE_EVENT_MOVE_UNIT, unit)
	end

	if keys.units["0"] and (keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET) then
		local unit = EntIndexToHScript(keys.units["0"])
		Voices:PlayLine(VOICE_EVENT_ATTACK_UNIT, unit)
	end

	return true
end

-- Called right after the game setup is finished, as the first player finishes loading into the game
function GameMode:OnFirstPlayerLoaded()
	print("First player has finished loading the gamemode")

end

function GameMode:OnGameStatePlayersLoading()
	print("Game state is now: players loading")
end

function GameMode:OnGameStateGameSetup()
	print("Game state is now: game setup")

	if IsInToolsMode() then
		--SendToServerConsole("dota_bot_populate")
	end
end

-- Called during hero select, performs additional precaching
function GameMode:PostLoadPrecache()
	print("Performing post-load precache...")    
	--PrecacheItemByNameAsync("item_example_item", function(...) end)
	--PrecacheItemByNameAsync("example_ability", function(...) end)
	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
end

function GameMode:OnGameStateHeroSelect()
	print("Game state is now: hero selection")

	Kingdom:Init()
end

function GameMode:OnGameStateStrategyTime()
	print("Game state is now: strategy time")
end

function GameMode:OnGameStateShowcaseTime()
	print("Game state is now: showcase time")
end

function GameMode:OnGameStatePreGame()
	print("Game state is now: pre-game")

	local time_threshold = -25
	if IsInToolsMode() then
		time_threshold = -10
	end

	Timers:CreateTimer(0, function()
		if GameRules:GetDOTATime(false, true) >= time_threshold then
			Kingdom:StartMatch()
		else
			return 0.03
		end
	end)
end

function GameMode:OnGameInProgress()
	if IsServer() then
		print("The game has officially begun")
	end
end