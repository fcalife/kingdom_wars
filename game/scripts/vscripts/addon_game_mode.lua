-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc
require('kingdom_wars')

-- Libraries and startup files
require('libraries/timers')
require('libraries/playertables')
require('internal/gamesetup')
require('internal/events')
require('internal/util')
require('events')

-- Initialize Kingdom core
require('kingdom/core')

function Precache(context)

	-- Gamemode loading precache
	print("Performing pre-load precache")

	-- Examples
	-- PrecacheResource("particle", "particles/dev/library/base_dust_hit_detail.vpcf", context)
	-- PrecacheResource("particle_folder", "particles/test_particle", context)
	-- PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
	-- PrecacheResource("model_folder", "particles/heroes/antimage", context)
	-- PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context)
	-- PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	-- PrecacheItemByNameSync("example_ability", context)

	-- Core sounds
	PrecacheResource("soundfile", "soundevents/kingdom_soundevents.vsndevts", context)

	-- We done
	print("Finished pre-load precache")
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:_InitGameMode()
end