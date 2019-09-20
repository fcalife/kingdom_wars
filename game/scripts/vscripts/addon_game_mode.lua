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
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context)

	-- Unit sounds
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context)

	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_shadow_demon.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context)

	-- Core particles
	PrecacheResource("particle", "particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_luna/luna_moon_glaive_bounce.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_rattletrap/rattletrap_hookshot.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf", context)
	PrecacheResource("particle", "particles/status_fx/status_effect_stickynapalm.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_4stack.vpcf", context)

	PrecacheResource("particle", "particles/capture_ring.vpcf", context)
	PrecacheResource("particle", "particles/returned.vpcf", context)
	PrecacheResource("particle", "particles/shrapnel.vpcf", context)

	-- We done
	print("Finished pre-load precache")
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:_InitGameMode()
end