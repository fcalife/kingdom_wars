-- Character voice system

Voices = class({});

function Voices:Init()

	-- Voice event enums
	VOICE_EVENT_SPAWN_UNIT = 1
	VOICE_EVENT_SELECT_UNIT = 2
	VOICE_EVENT_MOVE_UNIT = 3
	VOICE_EVENT_ATTACK_UNIT = 4

	-- Units with voices
	Voices.voiced_units = {
		"npc_kingdom_human_melee",
		"npc_kingdom_human_ranged",
		"npc_kingdom_human_cavalry",
		"npc_kingdom_hero_paladin",
		"npc_kingdom_hero_mage",
		"npc_kingdom_hero_commander",
		"npc_kingdom_elf_melee",
		"npc_kingdom_elf_ranged",
		"npc_kingdom_elf_cavalry",
		"npc_kingdom_hero_ranger",
		"npc_kingdom_hero_druid",
		"npc_kingdom_hero_assassin",
		"npc_kingdom_undead_melee",
		"npc_kingdom_undead_ranged",
		"npc_kingdom_undead_cavalry",
		"npc_kingdom_hero_necromancer",
		"npc_kingdom_hero_wraith_king",
		"npc_kingdom_hero_butcher",
		"npc_kingdom_keen_melee",
		"npc_kingdom_keen_ranged",
		"npc_kingdom_keen_cavalry",
		"npc_kingdom_hero_bounty_hunter",
		"npc_kingdom_hero_tinker",
		"npc_kingdom_hero_engineer",
		"npc_kingdom_orc_melee",
		"npc_kingdom_orc_ranged",
		"npc_kingdom_orc_cavalry",
		"npc_kingdom_hero_incursor",
		"npc_kingdom_hero_warlord",
		"npc_kingdom_hero_blademaster",
		"npc_kingdom_demon_melee",
		"npc_kingdom_demon_ranged",
		"npc_kingdom_demon_cavalry",
		"npc_kingdom_hero_nevermore",
		"npc_kingdom_hero_duchess",
		"npc_kingdom_hero_doom",
		"npc_kingdom_beast_2",
		"npc_kingdom_beast_5"
	}

	-- Event lines
	Voices.lines = {}

	Voices.lines[VOICE_EVENT_SPAWN_UNIT] = {}
	Voices.lines[VOICE_EVENT_SPAWN_UNIT].cooldown = 0.5
	Voices.lines[VOICE_EVENT_SELECT_UNIT] = {}
	Voices.lines[VOICE_EVENT_SELECT_UNIT].cooldown = 2.5
	Voices.lines[VOICE_EVENT_MOVE_UNIT] = {}
	Voices.lines[VOICE_EVENT_MOVE_UNIT].cooldown = 2.5
	Voices.lines[VOICE_EVENT_ATTACK_UNIT] = {}
	Voices.lines[VOICE_EVENT_ATTACK_UNIT].cooldown = 2.5

	for _, unit in pairs(Voices.voiced_units) do
		Voices.lines[unit] = {}
	end

	Voices.lines["npc_kingdom_human_melee"][VOICE_EVENT_SPAWN_UNIT] = {
		"dragon_knight_drag_spawn_01",
		"dragon_knight_drag_spawn_02",
		"dragon_knight_drag_spawn_03",
		"dragon_knight_drag_spawn_04"
	}

	Voices.lines["npc_kingdom_human_melee"][VOICE_EVENT_MOVE_UNIT] = {
		"dragon_knight_drag_move_01",
		"dragon_knight_drag_move_02",
		"dragon_knight_drag_move_03",
		"dragon_knight_drag_move_04",
		"dragon_knight_drag_move_05",
		"dragon_knight_drag_move_06",
		"dragon_knight_drag_move_07",
		"dragon_knight_drag_move_08",
		"dragon_knight_drag_move_09",
		"dragon_knight_drag_move_10",
		"dragon_knight_drag_move_11",
		"dragon_knight_drag_move_12"
	}

	Voices.lines["npc_kingdom_human_melee"][VOICE_EVENT_ATTACK_UNIT] = {
		"dragon_knight_drag_attack_01",
		"dragon_knight_drag_attack_02",
		"dragon_knight_drag_attack_03",
		"dragon_knight_drag_attack_04",
		"dragon_knight_drag_attack_05",
		"dragon_knight_drag_attack_06",
		"dragon_knight_drag_attack_07",
		"dragon_knight_drag_attack_08",
		"dragon_knight_drag_attack_09",
		"dragon_knight_drag_attack_10"
	}

	Voices.lines["npc_kingdom_human_ranged"][VOICE_EVENT_SPAWN_UNIT] = {
		"lina_lina_spawn_01",
		"lina_lina_spawn_02",
		"lina_lina_spawn_03",
		"lina_lina_spawn_04",
		"lina_lina_spawn_05",
		"lina_lina_spawn_06",
		"lina_lina_spawn_07",
		"lina_lina_spawn_08",
		"lina_lina_spawn_09"
	}

	Voices.lines["npc_kingdom_human_ranged"][VOICE_EVENT_MOVE_UNIT] = {
		"lina_lina_move_01",
		"lina_lina_move_02",
		"lina_lina_move_03",
		"lina_lina_move_04",
		"lina_lina_move_05",
		"lina_lina_move_06",
		"lina_lina_move_07",
		"lina_lina_move_08",
		"lina_lina_move_09",
		"lina_lina_move_10",
		"lina_lina_move_11",
		"lina_lina_move_12"
	}

	Voices.lines["npc_kingdom_human_ranged"][VOICE_EVENT_ATTACK_UNIT] = {
		"lina_lina_attack_01",
		"lina_lina_attack_02",
		"lina_lina_attack_03",
		"lina_lina_attack_04",
		"lina_lina_attack_05",
		"lina_lina_attack_06",
		"lina_lina_attack_07",
		"lina_lina_attack_08",
		"lina_lina_attack_09",
		"lina_lina_attack_10"
	}

	Voices.lines["npc_kingdom_human_cavalry"][VOICE_EVENT_SPAWN_UNIT] = {
		"keeper_of_the_light_keep_spawn_01",
		"keeper_of_the_light_keep_spawn_02",
		"keeper_of_the_light_keep_spawn_03",
		"keeper_of_the_light_keep_spawn_04",
		"keeper_of_the_light_keep_spawn_05"
	}

	Voices.lines["npc_kingdom_human_cavalry"][VOICE_EVENT_MOVE_UNIT] = {
		"keeper_of_the_light_keep_move_01",
		"keeper_of_the_light_keep_move_02",
		"keeper_of_the_light_keep_move_03",
		"keeper_of_the_light_keep_move_04",
		"keeper_of_the_light_keep_move_05",
		"keeper_of_the_light_keep_move_06",
		"keeper_of_the_light_keep_move_07",
		"keeper_of_the_light_keep_move_08",
		"keeper_of_the_light_keep_move_09",
		"keeper_of_the_light_keep_move_10",
		"keeper_of_the_light_keep_move_11",
		"keeper_of_the_light_keep_move_12",
		"keeper_of_the_light_keep_move_13",
		"keeper_of_the_light_keep_move_14",
		"keeper_of_the_light_keep_move_15",
		"keeper_of_the_light_keep_move_16",
		"keeper_of_the_light_keep_move_17",
		"keeper_of_the_light_keep_move_18",
		"keeper_of_the_light_keep_move_19"
	}

	Voices.lines["npc_kingdom_human_cavalry"][VOICE_EVENT_ATTACK_UNIT] = {
		"keeper_of_the_light_keep_attack_01",
		"keeper_of_the_light_keep_attack_02",
		"keeper_of_the_light_keep_attack_03",
		"keeper_of_the_light_keep_attack_04",
		"keeper_of_the_light_keep_attack_05",
		"keeper_of_the_light_keep_attack_06",
		"keeper_of_the_light_keep_attack_07",
		"keeper_of_the_light_keep_attack_08",
		"keeper_of_the_light_keep_attack_09",
		"keeper_of_the_light_keep_attack_10"
	}

	Voices.lines["npc_kingdom_hero_paladin"][VOICE_EVENT_MOVE_UNIT] = {
		"omniknight_omni_move_01",
		"omniknight_omni_move_02",
		"omniknight_omni_move_03",
		"omniknight_omni_move_04",
		"omniknight_omni_move_05",
		"omniknight_omni_move_06",
		"omniknight_omni_move_07",
		"omniknight_omni_move_08",
		"omniknight_omni_move_09",
		"omniknight_omni_move_10",
		"omniknight_omni_move_11",
		"omniknight_omni_move_12",
		"omniknight_omni_move_13",
		"omniknight_omni_move_14",
		"omniknight_omni_move_15",
		"omniknight_omni_move_16",
		"omniknight_omni_move_17",
		"omniknight_omni_move_18",
		"omniknight_omni_move_19",
		"omniknight_omni_move_20",
		"omniknight_omni_move_21",
		"omniknight_omni_move_22",
		"omniknight_omni_move_23"
	}

	Voices.lines["npc_kingdom_hero_paladin"][VOICE_EVENT_ATTACK_UNIT] = {
		"omniknight_omni_attack_01",
		"omniknight_omni_attack_02",
		"omniknight_omni_attack_03",
		"omniknight_omni_attack_04",
		"omniknight_omni_attack_05",
		"omniknight_omni_attack_06",
		"omniknight_omni_attack_07",
		"omniknight_omni_attack_08",
		"omniknight_omni_attack_09",
		"omniknight_omni_attack_10",
		"omniknight_omni_attack_11",
		"omniknight_omni_attack_12"
	}

	Voices.lines["npc_kingdom_hero_mage"][VOICE_EVENT_MOVE_UNIT] = {
		"crystalmaiden_cm_move_01",
		"crystalmaiden_cm_move_02",
		"crystalmaiden_cm_move_03",
		"crystalmaiden_cm_move_04",
		"crystalmaiden_cm_move_05",
		"crystalmaiden_cm_move_06",
		"crystalmaiden_cm_move_07",
		"crystalmaiden_cm_move_08",
		"crystalmaiden_cm_move_09",
		"crystalmaiden_cm_move_10",
		"crystalmaiden_cm_move_11",
		"crystalmaiden_cm_move_12",
		"crystalmaiden_cm_move_13",
		"crystalmaiden_cm_move_14",
		"crystalmaiden_cm_move_15"
	}

	Voices.lines["npc_kingdom_hero_mage"][VOICE_EVENT_ATTACK_UNIT] = {
		"crystalmaiden_cm_attack_01",
		"crystalmaiden_cm_attack_02",
		"crystalmaiden_cm_attack_03",
		"crystalmaiden_cm_attack_04",
		"crystalmaiden_cm_attack_06",
		"crystalmaiden_cm_attack_07",
		"crystalmaiden_cm_attack_05",
		"crystalmaiden_cm_attack_08",
		"crystalmaiden_cm_attack_09"
	}

	Voices.lines["npc_kingdom_hero_commander"][VOICE_EVENT_MOVE_UNIT] = {
		"mars_mars_move_01",
		"mars_mars_move_02",
		"mars_mars_move_03",
		"mars_mars_move_04",
		"mars_mars_move_05",
		"mars_mars_move_05_02",
		"mars_mars_move_06",
		"mars_mars_move_07",
		"mars_mars_move_08",
		"mars_mars_move_09",
		"mars_mars_move_11",
		"mars_mars_move_12",
		"mars_mars_move_13",
		"mars_mars_move_14",
		"mars_mars_move_15",
		"mars_mars_move_16",
		"mars_mars_move_17",
		"mars_mars_move_18",
		"mars_mars_move_19",
		"mars_mars_move_20",
		"mars_mars_move_21",
		"mars_mars_move_22",
		"mars_mars_move_23",
		"mars_mars_move_24",
		"mars_mars_move_25",
		"mars_mars_move_26",
		"mars_mars_move_27",
		"mars_mars_move_28_02",
		"mars_mars_move_28_03",
		"mars_mars_move_28_04",
		"mars_mars_move_29",
		"mars_mars_move_30",
		"mars_mars_move_31",
		"mars_mars_move_32",
		"mars_mars_move_33",
		"mars_mars_move_34",
		"mars_mars_move_35",
		"mars_mars_move_36",
		"mars_mars_move_37",
		"mars_mars_move_38",
		"mars_mars_move_39",
		"mars_mars_move_39_02",
		"mars_mars_move_40",
		"mars_mars_move_41",
		"mars_mars_move_42",
		"mars_mars_move_43",
		"mars_mars_move_44",
		"mars_mars_move_45",
		"mars_mars_move_46",
		"mars_mars_move_47"
	}

	Voices.lines["npc_kingdom_hero_commander"][VOICE_EVENT_ATTACK_UNIT] = {
		"mars_mars_attack_01",
		"mars_mars_attack_01_02",
		"mars_mars_attack_02",
		"mars_mars_attack_03",
		"mars_mars_attack_04",
		"mars_mars_attack_05",
		"mars_mars_attack_06",
		"mars_mars_attack_07",
		"mars_mars_attack_08",
		"mars_mars_attack_09",
		"mars_mars_attack_10",
		"mars_mars_attack_11",
		"mars_mars_attack_12",
		"mars_mars_attack_13",
		"mars_mars_attack_14",
		"mars_mars_attack_15",
		"mars_mars_attack_16",
		"mars_mars_attack_17",
		"mars_mars_attack_18",
		"mars_mars_attack_19",
		"mars_mars_attack_20",
		"mars_mars_attack_21",
		"mars_mars_attack_22",
		"mars_mars_attack_23",
		"mars_mars_attack_24"
	}

	Voices.lines["npc_kingdom_elf_melee"][VOICE_EVENT_SPAWN_UNIT] = {
		"silencer_silen_spawn_01",
		"silencer_silen_spawn_02",
		"silencer_silen_spawn_03",
		"silencer_silen_spawn_04"
	}

	Voices.lines["npc_kingdom_elf_melee"][VOICE_EVENT_MOVE_UNIT] = {
		"silencer_silen_move_01",
		"silencer_silen_move_02",
		"silencer_silen_move_03",
		"silencer_silen_move_04",
		"silencer_silen_move_05",
		"silencer_silen_move_06",
		"silencer_silen_move_07",
		"silencer_silen_move_08",
		"silencer_silen_move_09",
		"silencer_silen_move_10",
		"silencer_silen_move_11",
		"silencer_silen_move_12",
		"silencer_silen_move_13",
		"silencer_silen_move_14"
	}

	Voices.lines["npc_kingdom_elf_melee"][VOICE_EVENT_ATTACK_UNIT] = {
		"silencer_silen_attack_01",
		"silencer_silen_attack_02",
		"silencer_silen_attack_03",
		"silencer_silen_attack_04",
		"silencer_silen_attack_05",
		"silencer_silen_attack_06",
		"silencer_silen_attack_07",
		"silencer_silen_attack_08",
		"silencer_silen_attack_09",
		"silencer_silen_attack_10",
		"silencer_silen_attack_11",
		"silencer_silen_attack_12",
		"silencer_silen_attack_13",
		"silencer_silen_attack_14",
		"silencer_silen_attack_15"
	}

	Voices.lines["npc_kingdom_elf_ranged"][VOICE_EVENT_SPAWN_UNIT] = {
		"windrunner_wind_spawn_01",
		"windrunner_wind_spawn_02",
		"windrunner_wind_spawn_03",
		"windrunner_wind_spawn_04",
		"windrunner_wind_spawn_05",
		"windrunner_wind_spawn_06",
		"windrunner_wind_spawn_07",
		"windrunner_wind_spawn_08"
	}

	Voices.lines["npc_kingdom_elf_ranged"][VOICE_EVENT_MOVE_UNIT] = {
		"windrunner_wind_move_01",
		"windrunner_wind_move_02",
		"windrunner_wind_move_03",
		"windrunner_wind_move_04",
		"windrunner_wind_move_05",
		"windrunner_wind_move_06",
		"windrunner_wind_move_07",
		"windrunner_wind_move_09",
		"windrunner_wind_move_08",
		"windrunner_wind_move_10",
		"windrunner_wind_move_11",
		"windrunner_wind_move_12"
	}

	Voices.lines["npc_kingdom_elf_ranged"][VOICE_EVENT_ATTACK_UNIT] = {
		"windrunner_wind_attack_01",
		"windrunner_wind_attack_02",
		"windrunner_wind_attack_03",
		"windrunner_wind_attack_04",
		"windrunner_wind_attack_05",
		"windrunner_wind_attack_06",
		"windrunner_wind_attack_07",
		"windrunner_wind_attack_08",
		"windrunner_wind_attack_09",
		"windrunner_wind_attack_10",
		"windrunner_wind_attack_11",
		"windrunner_wind_attack_12",
		"windrunner_wind_attack_13"
	}

	Voices.lines["npc_kingdom_elf_cavalry"][VOICE_EVENT_SPAWN_UNIT] = {
		"luna_luna_spawn_01",
		"luna_luna_spawn_02",
		"luna_luna_spawn_03",
		"luna_luna_spawn_04"
	}

	Voices.lines["npc_kingdom_elf_cavalry"][VOICE_EVENT_MOVE_UNIT] = {
		"luna_luna_move_01",
		"luna_luna_move_02",
		"luna_luna_move_03",
		"luna_luna_move_04",
		"luna_luna_move_05",
		"luna_luna_move_06",
		"luna_luna_move_07",
		"luna_luna_move_08",
		"luna_luna_move_09",
		"luna_luna_move_10",
		"luna_luna_move_11",
		"luna_luna_move_12",
		"luna_luna_move_13",
		"luna_luna_move_14",
		"luna_luna_move_15",
		"luna_luna_move_16",
		"luna_luna_move_17",
		"luna_luna_move_18",
		"luna_luna_move_19",
		"luna_luna_move_20"
	}

	Voices.lines["npc_kingdom_elf_cavalry"][VOICE_EVENT_ATTACK_UNIT] = {
		"luna_luna_attack_01",
		"luna_luna_attack_02",
		"luna_luna_attack_03",
		"luna_luna_attack_04",
		"luna_luna_attack_05",
		"luna_luna_attack_06",
		"luna_luna_attack_07",
		"luna_luna_attack_08",
		"luna_luna_attack_09",
		"luna_luna_attack_10",
		"luna_luna_attack_11",
		"luna_luna_attack_12",
		"luna_luna_attack_13",
		"luna_luna_attack_14",
		"luna_luna_attack_15",
		"luna_luna_attack_16",
		"luna_luna_attack_17",
		"luna_luna_attack_18",
		"luna_luna_attack_19",
		"luna_luna_attack_20",
		"luna_luna_attack_21",
		"luna_luna_attack_22",
		"luna_luna_attack_23",
		"luna_luna_attack_24",
		"luna_luna_attack_25",
		"luna_luna_attack_26",
		"luna_luna_attack_27",
		"luna_luna_attack_28"
	}

	Voices.lines["npc_kingdom_hero_ranger"][VOICE_EVENT_MOVE_UNIT] = {
		"drowranger_dro_move_01",
		"drowranger_dro_move_02",
		"drowranger_dro_move_03",
		"drowranger_dro_move_04",
		"drowranger_dro_move_05",
		"drowranger_dro_move_06",
		"drowranger_dro_move_07",
		"drowranger_dro_move_08",
		"drowranger_dro_move_09",
		"drowranger_dro_move_10",
		"drowranger_dro_move_11",
		"drowranger_dro_move_12",
		"drowranger_dro_move_13",
		"drowranger_dro_move_14"
	}

	Voices.lines["npc_kingdom_hero_ranger"][VOICE_EVENT_ATTACK_UNIT] = {
		"drowranger_dro_attack_01",
		"drowranger_dro_attack_02",
		"drowranger_dro_attack_03",
		"drowranger_dro_attack_04",
		"drowranger_dro_attack_05",
		"drowranger_dro_attack_06",
		"drowranger_dro_attack_07",
		"drowranger_dro_attack_08",
		"drowranger_dro_attack_09",
		"drowranger_dro_attack_10",
		"drowranger_dro_attack_11"
	}

	Voices.lines["npc_kingdom_hero_druid"][VOICE_EVENT_MOVE_UNIT] = {
		"furion_furi_move_01",
		"furion_furi_move_02",
		"furion_furi_move_03",
		"furion_furi_move_04",
		"furion_furi_move_05",
		"furion_furi_move_06",
		"furion_furi_move_07",
		"furion_furi_move_08",
		"furion_furi_move_09",
		"furion_furi_move_10",
		"furion_furi_move_11",
		"furion_furi_move_12",
		"furion_furi_move_13",
		"furion_furi_move_14",
		"furion_furi_move_15",
		"furion_furi_move_16"
	}

	Voices.lines["npc_kingdom_hero_druid"][VOICE_EVENT_ATTACK_UNIT] = {
		"furion_furi_attack_01",
		"furion_furi_attack_02",
		"furion_furi_attack_03",
		"furion_furi_attack_04",
		"furion_furi_attack_05",
		"furion_furi_attack_06",
		"furion_furi_attack_07",
		"furion_furi_attack_08",
		"furion_furi_attack_09",
		"furion_furi_attack_10",
		"furion_furi_attack_11"
	}

	Voices.lines["npc_kingdom_hero_assassin"][VOICE_EVENT_MOVE_UNIT] = {
		"phantom_assassin_phass_move_01",
		"phantom_assassin_phass_move_02",
		"phantom_assassin_phass_move_03",
		"phantom_assassin_phass_move_04",
		"phantom_assassin_phass_move_05",
		"phantom_assassin_phass_move_06",
		"phantom_assassin_phass_move_07",
		"phantom_assassin_phass_move_08",
		"phantom_assassin_phass_move_09",
		"phantom_assassin_phass_move_10",
		"phantom_assassin_phass_move_11",
		"phantom_assassin_phass_move_12",
		"phantom_assassin_phass_move_13",
		"phantom_assassin_phass_move_14",
		"phantom_assassin_phass_move_15",
		"phantom_assassin_phass_move_16",
		"phantom_assassin_phass_move_17",
		"phantom_assassin_phass_move_18",
		"phantom_assassin_phass_move_19"
	}

	Voices.lines["npc_kingdom_hero_assassin"][VOICE_EVENT_ATTACK_UNIT] = {
		"phantom_assassin_phass_attack_01",
		"phantom_assassin_phass_attack_02",
		"phantom_assassin_phass_attack_03",
		"phantom_assassin_phass_attack_04",
		"phantom_assassin_phass_attack_05",
		"phantom_assassin_phass_attack_06",
		"phantom_assassin_phass_attack_07",
		"phantom_assassin_phass_attack_08",
		"phantom_assassin_phass_attack_09",
		"phantom_assassin_phass_attack_10"
	}

	Voices.lines["npc_kingdom_undead_melee"][VOICE_EVENT_SPAWN_UNIT] = {
		"undying_undying_spawn_01",
		"undying_undying_spawn_02",
		"undying_undying_spawn_03",
		"undying_undying_spawn_04",
		"undying_undying_spawn_05"
	}

	Voices.lines["npc_kingdom_undead_melee"][VOICE_EVENT_MOVE_UNIT] = {
		"undying_undying_move_01",
		"undying_undying_move_02",
		"undying_undying_move_03",
		"undying_undying_move_04",
		"undying_undying_move_05",
		"undying_undying_move_06",
		"undying_undying_move_07",
		"undying_undying_move_08",
		"undying_undying_move_09",
		"undying_undying_move_10",
		"undying_undying_move_11",
		"undying_undying_move_12",
		"undying_undying_move_13",
		"undying_undying_move_15",
		"undying_undying_move_16",
		"undying_undying_move_17",
		"undying_undying_move_18",
		"undying_undying_move_19",
		"undying_undying_move_20"
	}

	Voices.lines["npc_kingdom_undead_melee"][VOICE_EVENT_ATTACK_UNIT] = {
		"undying_undying_attack_01",
		"undying_undying_attack_02",
		"undying_undying_attack_03",
		"undying_undying_attack_04",
		"undying_undying_attack_05",
		"undying_undying_attack_06",
		"undying_undying_attack_07",
		"undying_undying_attack_08",
		"undying_undying_attack_09",
		"undying_undying_attack_10",
		"undying_undying_attack_11",
		"undying_undying_attack_12",
		"undying_undying_attack_13",
		"undying_undying_attack_14",
		"undying_undying_attack_15",
		"undying_undying_attack_16",
		"undying_undying_attack_17",
		"undying_undying_attack_18",
		"undying_undying_attack_19"
	}

	Voices.lines["npc_kingdom_undead_ranged"][VOICE_EVENT_SPAWN_UNIT] = {
		"clinkz_clinkz_spawn_01",
		"clinkz_clinkz_spawn_02",
		"clinkz_clinkz_spawn_03",
		"clinkz_clinkz_spawn_04"
	}

	Voices.lines["npc_kingdom_undead_ranged"][VOICE_EVENT_MOVE_UNIT] = {
		"clinkz_clinkz_move_01",
		"clinkz_clinkz_move_02",
		"clinkz_clinkz_move_03",
		"clinkz_clinkz_move_04",
		"clinkz_clinkz_move_05",
		"clinkz_clinkz_move_06",
		"clinkz_clinkz_move_07",
		"clinkz_clinkz_move_08",
		"clinkz_clinkz_move_09",
		"clinkz_clinkz_move_10",
		"clinkz_clinkz_move_11",
		"clinkz_clinkz_move_12",
		"clinkz_clinkz_move_13",
		"clinkz_clinkz_move_14",
		"clinkz_clinkz_move_15"
	}

	Voices.lines["npc_kingdom_undead_ranged"][VOICE_EVENT_ATTACK_UNIT] = {
		"clinkz_clinkz_attack_01",
		"clinkz_clinkz_attack_02",
		"clinkz_clinkz_attack_03",
		"clinkz_clinkz_attack_04",
		"clinkz_clinkz_attack_05",
		"clinkz_clinkz_attack_06",
		"clinkz_clinkz_attack_07",
		"clinkz_clinkz_attack_08",
		"clinkz_clinkz_attack_09",
		"clinkz_clinkz_attack_10",
		"clinkz_clinkz_attack_11",
		"clinkz_clinkz_attack_12",
		"clinkz_clinkz_attack_13",
		"clinkz_clinkz_attack_14",
		"clinkz_clinkz_attack_15",
		"clinkz_clinkz_attack_16"
	}

	Voices.lines["npc_kingdom_undead_cavalry"][VOICE_EVENT_SPAWN_UNIT] = {
		"abaddon_abad_spawn_01",
		"abaddon_abad_spawn_02",
		"abaddon_abad_spawn_03",
		"abaddon_abad_spawn_04",
		"abaddon_abad_spawn_05",
		"abaddon_abad_laugh_01",
		"abaddon_abad_laugh_02",
		"abaddon_abad_laugh_03",
		"abaddon_abad_laugh_04",
		"abaddon_abad_laugh_05"
	}

	Voices.lines["npc_kingdom_undead_cavalry"][VOICE_EVENT_MOVE_UNIT] = {
		"abaddon_abad_move_01",
		"abaddon_abad_move_02",
		"abaddon_abad_move_03",
		"abaddon_abad_move_04",
		"abaddon_abad_move_05",
		"abaddon_abad_move_06",
		"abaddon_abad_move_07",
		"abaddon_abad_move_08",
		"abaddon_abad_move_09",
		"abaddon_abad_move_10",
		"abaddon_abad_move_11",
		"abaddon_abad_move_12",
		"abaddon_abad_move_13",
		"abaddon_abad_move_14",
		"abaddon_abad_move_15",
		"abaddon_abad_move_16",
		"abaddon_abad_move_17",
		"abaddon_abad_move_18",
		"abaddon_abad_move_19",
		"abaddon_abad_move_20",
		"abaddon_abad_move_21",
		"abaddon_abad_move_22"
	}

	Voices.lines["npc_kingdom_undead_cavalry"][VOICE_EVENT_ATTACK_UNIT] = {
		"abaddon_abad_attack_01",
		"abaddon_abad_attack_02",
		"abaddon_abad_attack_03",
		"abaddon_abad_attack_04",
		"abaddon_abad_attack_05",
		"abaddon_abad_attack_06",
		"abaddon_abad_attack_07",
		"abaddon_abad_attack_08",
		"abaddon_abad_attack_09",
		"abaddon_abad_attack_10",
		"abaddon_abad_attack_11",
		"abaddon_abad_attack_12",
		"abaddon_abad_attack_13"
	}

	Voices.lines["npc_kingdom_hero_necromancer"][VOICE_EVENT_MOVE_UNIT] = {
		"necrolyte_necr_move_01",
		"necrolyte_necr_move_02",
		"necrolyte_necr_move_03",
		"necrolyte_necr_move_04",
		"necrolyte_necr_move_05",
		"necrolyte_necr_move_06",
		"necrolyte_necr_move_07",
		"necrolyte_necr_move_08",
		"necrolyte_necr_move_09",
		"necrolyte_necr_move_10",
		"necrolyte_necr_move_11",
		"necrolyte_necr_move_12",
		"necrolyte_necr_move_13",
		"necrolyte_necr_move_14",
		"necrolyte_necr_move_15"
	}

	Voices.lines["npc_kingdom_hero_necromancer"][VOICE_EVENT_ATTACK_UNIT] = {
		"necrolyte_necr_attack_01",
		"necrolyte_necr_attack_02",
		"necrolyte_necr_attack_03",
		"necrolyte_necr_attack_04",
		"necrolyte_necr_attack_05",
		"necrolyte_necr_attack_06",
		"necrolyte_necr_attack_07",
		"necrolyte_necr_attack_08",
		"necrolyte_necr_attack_09",
		"necrolyte_necr_attack_10",
		"necrolyte_necr_attack_11",
		"necrolyte_necr_attack_12",
		"necrolyte_necr_attack_13",
		"necrolyte_necr_attack_14",
		"necrolyte_necr_attack_15",
		"necrolyte_necr_attack_16"
	}

	Voices.lines["npc_kingdom_hero_wraith_king"][VOICE_EVENT_MOVE_UNIT] = {
		"skeleton_king_wraith_move_01",
		"skeleton_king_wraith_move_02",
		"skeleton_king_wraith_move_03",
		"skeleton_king_wraith_move_04",
		"skeleton_king_wraith_move_05",
		"skeleton_king_wraith_move_06",
		"skeleton_king_wraith_move_07",
		"skeleton_king_wraith_move_08",
		"skeleton_king_wraith_move_09",
		"skeleton_king_wraith_move_10",
		"skeleton_king_wraith_move_11",
		"skeleton_king_wraith_move_12",
		"skeleton_king_wraith_move_13",
		"skeleton_king_wraith_move_14",
		"skeleton_king_wraith_move_15",
		"skeleton_king_wraith_move_16",
		"skeleton_king_wraith_move_17",
		"skeleton_king_wraith_move_18",
		"skeleton_king_wraith_move_19",
		"skeleton_king_wraith_move_20",
		"skeleton_king_wraith_move_21",
		"skeleton_king_wraith_move_22"
	}

	Voices.lines["npc_kingdom_hero_wraith_king"][VOICE_EVENT_ATTACK_UNIT] = {
		"skeleton_king_wraith_attack_01",
		"skeleton_king_wraith_attack_02",
		"skeleton_king_wraith_attack_03",
		"skeleton_king_wraith_attack_04",
		"skeleton_king_wraith_attack_05",
		"skeleton_king_wraith_attack_06",
		"skeleton_king_wraith_attack_07",
		"skeleton_king_wraith_attack_08",
		"skeleton_king_wraith_attack_09",
		"skeleton_king_wraith_attack_10",
		"skeleton_king_wraith_attack_11",
		"skeleton_king_wraith_attack_12",
		"skeleton_king_wraith_attack_13",
		"skeleton_king_wraith_attack_14",
		"skeleton_king_wraith_attack_15"
	}

	Voices.lines["npc_kingdom_hero_butcher"][VOICE_EVENT_MOVE_UNIT] = {
		"pudge_pud_move_01",
		"pudge_pud_move_03",
		"pudge_pud_move_04",
		"pudge_pud_move_05",
		"pudge_pud_move_06",
		"pudge_pud_move_07",
		"pudge_pud_move_09",
		"pudge_pud_move_10",
		"pudge_pud_move_11",
		"pudge_pud_move_12",
		"pudge_pud_move_13",
		"pudge_pud_move_15",
		"pudge_pud_move_16",
		"pudge_pud_move_17",
		"pudge_pud_move_14"
	}

	Voices.lines["npc_kingdom_hero_butcher"][VOICE_EVENT_ATTACK_UNIT] = {
		"pudge_pud_attack_01",
		"pudge_pud_attack_02",
		"pudge_pud_attack_03",
		"pudge_pud_attack_04",
		"pudge_pud_attack_05",
		"pudge_pud_attack_06",
		"pudge_pud_attack_08",
		"pudge_pud_attack_09",
		"pudge_pud_attack_10",
		"pudge_pud_attack_11",
		"pudge_pud_attack_12",
		"pudge_pud_attack_13",
		"pudge_pud_attack_14",
		"pudge_pud_attack_15",
		"pudge_pud_attack_16"
	}

	Voices.lines["npc_kingdom_keen_melee"][VOICE_EVENT_SPAWN_UNIT] = {
		"shredder_timb_spawn_01",
		"shredder_timb_spawn_02",
		"shredder_timb_spawn_03",
		"shredder_timb_spawn_04",
		"shredder_timb_spawn_05"
	}

	Voices.lines["npc_kingdom_keen_melee"][VOICE_EVENT_MOVE_UNIT] = {
		"shredder_timb_move_01",
		"shredder_timb_move_02",
		"shredder_timb_move_03",
		"shredder_timb_move_04",
		"shredder_timb_move_05",
		"shredder_timb_move_06",
		"shredder_timb_move_07",
		"shredder_timb_move_08",
		"shredder_timb_move_09",
		"shredder_timb_move_10",
		"shredder_timb_move_11",
		"shredder_timb_move_12",
		"shredder_timb_move_13",
		"shredder_timb_move_14",
		"shredder_timb_move_15",
		"shredder_timb_move_16",
		"shredder_timb_move_17"
	}

	Voices.lines["npc_kingdom_keen_melee"][VOICE_EVENT_ATTACK_UNIT] = {
		"shredder_timb_attack_01",
		"shredder_timb_attack_02",
		"shredder_timb_attack_03",
		"shredder_timb_attack_04",
		"shredder_timb_attack_05",
		"shredder_timb_attack_06",
		"shredder_timb_attack_07",
		"shredder_timb_attack_08",
		"shredder_timb_attack_09",
		"shredder_timb_attack_10",
		"shredder_timb_attack_11"
	}

	Voices.lines["npc_kingdom_keen_ranged"][VOICE_EVENT_SPAWN_UNIT] = {
		"techies_tech_spawn_01",
		"techies_tech_spawn_02",
		"techies_tech_spawn_03",
		"techies_tech_spawn_04",
		"techies_tech_spawn_05",
		"techies_tech_spawn_06"
	}

	Voices.lines["npc_kingdom_keen_ranged"][VOICE_EVENT_MOVE_UNIT] = {
		"techies_tech_move_01",
		"techies_tech_move_02",
		"techies_tech_move_03",
		"techies_tech_move_04",
		"techies_tech_move_06",
		"techies_tech_move_07",
		"techies_tech_move_08",
		"techies_tech_move_09",
		"techies_tech_move_10",
		"techies_tech_move_11",
		"techies_tech_move_12",
		"techies_tech_move_14",
		"techies_tech_move_16",
		"techies_tech_move_17",
		"techies_tech_move_18",
		"techies_tech_move_19",
		"techies_tech_move_20",
		"techies_tech_move_21",
		"techies_tech_move_22",
		"techies_tech_move_23",
		"techies_tech_move_24",
		"techies_tech_move_26",
		"techies_tech_move_27",
		"techies_tech_move_28",
		"techies_tech_move_30",
		"techies_tech_move_32",
		"techies_tech_move_33",
		"techies_tech_move_34",
		"techies_tech_move_36",
		"techies_tech_move_37",
		"techies_tech_move_38",
		"techies_tech_move_39",
		"techies_tech_move_40",
		"techies_tech_move_42",
		"techies_tech_move_43",
		"techies_tech_move_44",
		"techies_tech_move_45",
		"techies_tech_move_46",
		"techies_tech_move_47",
		"techies_tech_move_48",
		"techies_tech_move_49",
		"techies_tech_move_50",
		"techies_tech_move_51",
		"techies_tech_move_52",
		"techies_tech_move_53",
		"techies_tech_move_54",
		"techies_tech_move_56",
		"techies_tech_move_60"
	}

	Voices.lines["npc_kingdom_keen_ranged"][VOICE_EVENT_ATTACK_UNIT] = {
		"techies_tech_attack_01",
		"techies_tech_attack_02",
		"techies_tech_attack_03",
		"techies_tech_attack_05",
		"techies_tech_attack_06",
		"techies_tech_attack_07",
		"techies_tech_attack_09",
		"techies_tech_attack_12",
		"techies_tech_attack_13",
		"techies_tech_attack_14",
		"techies_tech_attack_15",
		"techies_tech_attack_16",
		"techies_tech_attack_19",
		"techies_tech_attack_20",
		"techies_tech_attack_21",
		"techies_tech_attack_22",
		"techies_tech_attack_23",
		"techies_tech_attack_24",
		"techies_tech_attack_25"
	}

	Voices.lines["npc_kingdom_keen_cavalry"][VOICE_EVENT_SPAWN_UNIT] = {
		"alchemist_alch_spawn_01",
		"alchemist_alch_spawn_02",
		"alchemist_alch_spawn_03",
		"alchemist_alch_spawn_04",
		"alchemist_alch_spawn_05",
		"alchemist_alch_spawn_06"
	}

	Voices.lines["npc_kingdom_keen_cavalry"][VOICE_EVENT_MOVE_UNIT] = {
		"alchemist_alch_move_01",
		"alchemist_alch_move_02",
		"alchemist_alch_move_03",
		"alchemist_alch_move_04",
		"alchemist_alch_move_05",
		"alchemist_alch_move_06",
		"alchemist_alch_move_07",
		"alchemist_alch_move_08",
		"alchemist_alch_move_09",
		"alchemist_alch_move_10",
		"alchemist_alch_move_11",
		"alchemist_alch_move_12",
		"alchemist_alch_move_13",
		"alchemist_alch_move_14",
		"alchemist_alch_move_15",
		"alchemist_alch_move_16",
		"alchemist_alch_move_17",
		"alchemist_alch_move_18",
		"alchemist_alch_move_19",
		"alchemist_alch_move_20",
		"alchemist_alch_move_21",
		"alchemist_alch_move_22",
		"alchemist_alch_move_23",
		"alchemist_alch_move_24",
		"alchemist_alch_move_25",
		"alchemist_alch_move_26",
		"alchemist_alch_move_27",
		"alchemist_alch_move_28",
		"alchemist_alch_move_29",
		"alchemist_alch_move_30",
		"alchemist_alch_move_31",
		"alchemist_alch_move_32",
		"alchemist_alch_move_33",
		"alchemist_alch_move_34",
		"alchemist_alch_move_35",
		"alchemist_alch_move_36",
		"alchemist_alch_move_37",
		"alchemist_alch_move_38",
		"alchemist_alch_move_39",
		"alchemist_alch_move_40",
		"alchemist_alch_move_41"
	}

	Voices.lines["npc_kingdom_keen_cavalry"][VOICE_EVENT_ATTACK_UNIT] = {
		"alchemist_alch_attack_01",
		"alchemist_alch_attack_02",
		"alchemist_alch_attack_03",
		"alchemist_alch_attack_04",
		"alchemist_alch_attack_05",
		"alchemist_alch_attack_06",
		"alchemist_alch_attack_07",
		"alchemist_alch_attack_08",
		"alchemist_alch_attack_09",
		"alchemist_alch_attack_10",
		"alchemist_alch_attack_11",
		"alchemist_alch_attack_12",
		"alchemist_alch_attack_13",
		"alchemist_alch_attack_14",
		"alchemist_alch_attack_15",
		"alchemist_alch_attack_16",
		"alchemist_alch_attack_17",
		"alchemist_alch_attack_18",
		"alchemist_alch_attack_19"
	}

	Voices.lines["npc_kingdom_hero_bounty_hunter"][VOICE_EVENT_MOVE_UNIT] = {
		"bounty_hunter_bount_move_01",
		"bounty_hunter_bount_move_02",
		"bounty_hunter_bount_move_03",
		"bounty_hunter_bount_move_04",
		"bounty_hunter_bount_move_05",
		"bounty_hunter_bount_move_06",
		"bounty_hunter_bount_move_07",
		"bounty_hunter_bount_move_08",
		"bounty_hunter_bount_move_09",
		"bounty_hunter_bount_move_10",
		"bounty_hunter_bount_move_11",
		"bounty_hunter_bount_move_12",
		"bounty_hunter_bount_move_13",
		"bounty_hunter_bount_move_14",
		"bounty_hunter_bount_move_15",
		"bounty_hunter_bount_move_16",
		"bounty_hunter_bount_move_17",
		"bounty_hunter_bount_move_18",
		"bounty_hunter_bount_move_19"
	}

	Voices.lines["npc_kingdom_hero_bounty_hunter"][VOICE_EVENT_ATTACK_UNIT] = {
		"bounty_hunter_bount_attack_01",
		"bounty_hunter_bount_attack_02",
		"bounty_hunter_bount_attack_03",
		"bounty_hunter_bount_attack_04",
		"bounty_hunter_bount_attack_05",
		"bounty_hunter_bount_attack_06",
		"bounty_hunter_bount_attack_07",
		"bounty_hunter_bount_attack_08",
		"bounty_hunter_bount_attack_09",
		"bounty_hunter_bount_attack_10",
		"bounty_hunter_bount_attack_11",
		"bounty_hunter_bount_attack_12",
		"bounty_hunter_bount_attack_13",
		"bounty_hunter_bount_attack_14"
	}

	Voices.lines["npc_kingdom_hero_tinker"][VOICE_EVENT_MOVE_UNIT] = {
		"tinker_tink_move_01",
		"tinker_tink_move_02",
		"tinker_tink_move_03",
		"tinker_tink_move_04",
		"tinker_tink_move_05",
		"tinker_tink_move_06",
		"tinker_tink_move_07",
		"tinker_tink_move_08",
		"tinker_tink_move_09",
		"tinker_tink_move_10",
		"tinker_tink_move_11",
		"tinker_tink_move_12"
	}

	Voices.lines["npc_kingdom_hero_tinker"][VOICE_EVENT_ATTACK_UNIT] = {
		"tinker_tink_attack_01",
		"tinker_tink_attack_02",
		"tinker_tink_attack_03",
		"tinker_tink_attack_04",
		"tinker_tink_attack_05",
		"tinker_tink_attack_06",
		"tinker_tink_attack_07",
		"tinker_tink_attack_08",
		"tinker_tink_attack_09",
		"tinker_tink_attack_10",
		"tinker_tink_attack_11",
		"tinker_tink_attack_12",
		"tinker_tink_attack_13",
		"tinker_tink_attack_14",
		"tinker_tink_attack_15"
	}

	Voices.lines["npc_kingdom_hero_engineer"][VOICE_EVENT_MOVE_UNIT] = {
		"gyrocopter_gyro_move_01",
		"gyrocopter_gyro_move_02",
		"gyrocopter_gyro_move_03",
		"gyrocopter_gyro_move_04",
		"gyrocopter_gyro_move_05",
		"gyrocopter_gyro_move_06",
		"gyrocopter_gyro_move_07",
		"gyrocopter_gyro_move_08",
		"gyrocopter_gyro_move_09",
		"gyrocopter_gyro_move_10",
		"gyrocopter_gyro_move_11",
		"gyrocopter_gyro_move_12",
		"gyrocopter_gyro_move_13",
		"gyrocopter_gyro_move_14",
		"gyrocopter_gyro_move_15",
		"gyrocopter_gyro_move_16",
		"gyrocopter_gyro_move_17",
		"gyrocopter_gyro_move_18",
		"gyrocopter_gyro_move_19",
		"gyrocopter_gyro_move_20",
		"gyrocopter_gyro_move_21",
		"gyrocopter_gyro_move_22",
		"gyrocopter_gyro_move_23",
		"gyrocopter_gyro_move_24",
		"gyrocopter_gyro_move_25",
		"gyrocopter_gyro_move_26",
		"gyrocopter_gyro_move_27",
		"gyrocopter_gyro_move_28",
		"gyrocopter_gyro_move_29",
		"gyrocopter_gyro_move_30",
		"gyrocopter_gyro_move_31",
		"gyrocopter_gyro_move_32"
	}

	Voices.lines["npc_kingdom_hero_engineer"][VOICE_EVENT_ATTACK_UNIT] = {
		"gyrocopter_gyro_attack_01",
		"gyrocopter_gyro_attack_02",
		"gyrocopter_gyro_attack_03",
		"gyrocopter_gyro_attack_04",
		"gyrocopter_gyro_attack_05",
		"gyrocopter_gyro_attack_06",
		"gyrocopter_gyro_attack_07",
		"gyrocopter_gyro_attack_08",
		"gyrocopter_gyro_attack_09",
		"gyrocopter_gyro_attack_10",
		"gyrocopter_gyro_attack_11",
		"gyrocopter_gyro_attack_12",
		"gyrocopter_gyro_attack_13",
		"gyrocopter_gyro_attack_14",
		"gyrocopter_gyro_attack_15",
		"gyrocopter_gyro_attack_16",
		"gyrocopter_gyro_attack_17",
		"gyrocopter_gyro_attack_18",
		"gyrocopter_gyro_attack_19"
	}

	Voices.lines["npc_kingdom_orc_melee"][VOICE_EVENT_SPAWN_UNIT] = {
		"axe_axe_spawn_01",
		"axe_axe_spawn_02",
		"axe_axe_spawn_03",
		"axe_axe_spawn_04",
		"axe_axe_spawn_05",
		"axe_axe_spawn_06",
		"axe_axe_spawn_07",
		"axe_axe_spawn_08",
		"axe_axe_spawn_09",
		"axe_axe_spawn_10"
	}

	Voices.lines["npc_kingdom_orc_melee"][VOICE_EVENT_MOVE_UNIT] = {
		"axe_axe_move_01",
		"axe_axe_move_02",
		"axe_axe_move_03",
		"axe_axe_move_04",
		"axe_axe_move_05",
		"axe_axe_move_06",
		"axe_axe_move_07",
		"axe_axe_move_08",
		"axe_axe_move_09",
		"axe_axe_move_10",
		"axe_axe_move_11"
	}

	Voices.lines["npc_kingdom_orc_melee"][VOICE_EVENT_ATTACK_UNIT] = {
		"axe_axe_attack_01",
		"axe_axe_attack_02",
		"axe_axe_attack_03",
		"axe_axe_attack_04",
		"axe_axe_attack_05",
		"axe_axe_attack_06",
		"axe_axe_attack_07",
		"axe_axe_attack_08",
		"axe_axe_attack_09",
		"axe_axe_attack_10"
	}

	Voices.lines["npc_kingdom_orc_ranged"][VOICE_EVENT_SPAWN_UNIT] = {
		"troll_warlord_troll_spawn_01",
		"troll_warlord_troll_spawn_02",
		"troll_warlord_troll_spawn_03",
		"troll_warlord_troll_spawn_04",
		"troll_warlord_troll_spawn_05",
		"troll_warlord_troll_spawn_06"
	}

	Voices.lines["npc_kingdom_orc_ranged"][VOICE_EVENT_MOVE_UNIT] = {
		"troll_warlord_troll_move_01",
		"troll_warlord_troll_move_02",
		"troll_warlord_troll_move_03",
		"troll_warlord_troll_move_04",
		"troll_warlord_troll_move_05",
		"troll_warlord_troll_move_06",
		"troll_warlord_troll_move_07",
		"troll_warlord_troll_move_08",
		"troll_warlord_troll_move_09",
		"troll_warlord_troll_move_10",
		"troll_warlord_troll_move_11",
		"troll_warlord_troll_move_12",
		"troll_warlord_troll_move_13",
		"troll_warlord_troll_move_14",
		"troll_warlord_troll_move_15"
	}

	Voices.lines["npc_kingdom_orc_ranged"][VOICE_EVENT_ATTACK_UNIT] = {
		"troll_warlord_troll_attack_01",
		"troll_warlord_troll_attack_02",
		"troll_warlord_troll_attack_03",
		"troll_warlord_troll_attack_04",
		"troll_warlord_troll_attack_05",
		"troll_warlord_troll_attack_06",
		"troll_warlord_troll_attack_07",
		"troll_warlord_troll_attack_08",
		"troll_warlord_troll_attack_09",
		"troll_warlord_troll_attack_10",
		"troll_warlord_troll_attack_11",
		"troll_warlord_troll_attack_12",
		"troll_warlord_troll_attack_13",
		"troll_warlord_troll_attack_14",
		"troll_warlord_troll_attack_15"
	}

	Voices.lines["npc_kingdom_orc_cavalry"][VOICE_EVENT_SPAWN_UNIT] = {
		"batrider_bat_spawn_01",
		"batrider_bat_spawn_02",
		"batrider_bat_spawn_03",
		"batrider_bat_spawn_04",
		"batrider_bat_spawn_05"
	}

	Voices.lines["npc_kingdom_orc_cavalry"][VOICE_EVENT_MOVE_UNIT] = {
		"batrider_bat_move_01",
		"batrider_bat_move_02",
		"batrider_bat_move_03",
		"batrider_bat_move_04",
		"batrider_bat_move_05",
		"batrider_bat_move_06",
		"batrider_bat_move_07",
		"batrider_bat_move_08",
		"batrider_bat_move_09",
		"batrider_bat_move_10",
		"batrider_bat_move_11",
		"batrider_bat_move_12",
		"batrider_bat_move_13",
		"batrider_bat_move_14",
		"batrider_bat_move_15",
		"batrider_bat_move_16",
		"batrider_bat_move_17",
		"batrider_bat_move_18",
		"batrider_bat_move_19",
		"batrider_bat_move_20",
		"batrider_bat_move_21",
		"batrider_bat_move_22"
	}

	Voices.lines["npc_kingdom_orc_cavalry"][VOICE_EVENT_ATTACK_UNIT] = {
		"batrider_bat_attack_01",
		"batrider_bat_attack_02",
		"batrider_bat_attack_03",
		"batrider_bat_attack_04",
		"batrider_bat_attack_05",
		"batrider_bat_attack_06",
		"batrider_bat_attack_07",
		"batrider_bat_attack_08",
		"batrider_bat_attack_09",
		"batrider_bat_attack_10",
		"batrider_bat_attack_11",
		"batrider_bat_attack_12",
		"batrider_bat_attack_13",
		"batrider_bat_attack_14"
	}

	Voices.lines["npc_kingdom_hero_incursor"][VOICE_EVENT_MOVE_UNIT] = {
		"disruptor_dis_move_01",
		"disruptor_dis_move_03",
		"disruptor_dis_move_04",
		"disruptor_dis_move_05",
		"disruptor_dis_move_06",
		"disruptor_dis_move_07",
		"disruptor_dis_move_08",
		"disruptor_dis_move_09",
		"disruptor_dis_move_10",
		"disruptor_dis_move_11",
		"disruptor_dis_move_12"
	}

	Voices.lines["npc_kingdom_hero_incursor"][VOICE_EVENT_ATTACK_UNIT] = {
		"disruptor_dis_attack_01",
		"disruptor_dis_attack_02",
		"disruptor_dis_attack_03",
		"disruptor_dis_attack_04",
		"disruptor_dis_attack_05",
		"disruptor_dis_attack_06",
		"disruptor_dis_attack_07",
		"disruptor_dis_attack_08",
		"disruptor_dis_attack_09",
		"disruptor_dis_attack_10"
	}

	Voices.lines["npc_kingdom_hero_warlord"][VOICE_EVENT_MOVE_UNIT] = {
		"elder_titan_elder_move_01",
		"elder_titan_elder_move_02",
		"elder_titan_elder_move_03",
		"elder_titan_elder_move_04",
		"elder_titan_elder_move_05",
		"elder_titan_elder_move_06",
		"elder_titan_elder_move_07",
		"elder_titan_elder_move_08",
		"elder_titan_elder_move_09",
		"elder_titan_elder_move_10",
		"elder_titan_elder_move_11",
		"elder_titan_elder_move_12",
		"elder_titan_elder_move_13",
		"elder_titan_elder_move_14",
		"elder_titan_elder_move_15",
		"elder_titan_elder_move_16",
		"elder_titan_elder_move_17",
		"elder_titan_elder_move_18",
		"elder_titan_elder_move_19"
	}

	Voices.lines["npc_kingdom_hero_warlord"][VOICE_EVENT_ATTACK_UNIT] = {
		"elder_titan_elder_attack_01",
		"elder_titan_elder_attack_02",
		"elder_titan_elder_attack_03",
		"elder_titan_elder_attack_04",
		"elder_titan_elder_attack_05",
		"elder_titan_elder_attack_06",
		"elder_titan_elder_attack_07",
		"elder_titan_elder_attack_08",
		"elder_titan_elder_attack_09",
		"elder_titan_elder_attack_10",
		"elder_titan_elder_attack_11",
		"elder_titan_elder_attack_12",
		"elder_titan_elder_attack_13",
		"elder_titan_elder_attack_14"
	}

	Voices.lines["npc_kingdom_hero_blademaster"][VOICE_EVENT_MOVE_UNIT] = {
		"juggernaut_jug_move_01",
		"juggernaut_jug_move_02",
		"juggernaut_jug_move_03",
		"juggernaut_jug_move_04",
		"juggernaut_jug_move_05",
		"juggernaut_jug_move_06",
		"juggernaut_jug_move_07",
		"juggernaut_jug_move_09",
		"juggernaut_jug_move_10",
		"juggernaut_jug_move_11",
		"juggernaut_jug_move_12",
		"juggernaut_jug_move_13",
		"juggernaut_jug_move_14",
		"juggernaut_jug_move_15",
		"juggernaut_jug_move_16",
		"juggernaut_jug_move_17",
		"juggernaut_jug_move_18",
		"juggernaut_jug_move_19"
	}

	Voices.lines["npc_kingdom_hero_blademaster"][VOICE_EVENT_ATTACK_UNIT] = {
		"juggernaut_jug_attack_01",
		"juggernaut_jug_attack_02",
		"juggernaut_jug_attack_03",
		"juggernaut_jug_attack_04",
		"juggernaut_jug_attack_05",
		"juggernaut_jug_attack_06",
		"juggernaut_jug_attack_07",
		"juggernaut_jug_attack_08",
		"juggernaut_jug_attack_09",
		"juggernaut_jug_attack_10",
		"juggernaut_jug_attack_11",
		"juggernaut_jug_attack_12",
		"juggernaut_jug_attack_13"
	}

	Voices.lines["npc_kingdom_demon_melee"][VOICE_EVENT_SPAWN_UNIT] = {
		"night_stalker_nstalk_spawn_01",
		"night_stalker_nstalk_spawn_02",
		"night_stalker_nstalk_spawn_03",
		"night_stalker_nstalk_spawn_04",
		"night_stalker_nstalk_spawn_05"
	}

	Voices.lines["npc_kingdom_demon_melee"][VOICE_EVENT_MOVE_UNIT] = {
		"night_stalker_nstalk_move_01",
		"night_stalker_nstalk_move_02",
		"night_stalker_nstalk_move_03",
		"night_stalker_nstalk_move_04",
		"night_stalker_nstalk_move_05",
		"night_stalker_nstalk_move_06",
		"night_stalker_nstalk_move_07",
		"night_stalker_nstalk_move_08",
		"night_stalker_nstalk_move_09",
		"night_stalker_nstalk_move_10",
		"night_stalker_nstalk_move_11",
		"night_stalker_nstalk_move_12",
		"night_stalker_nstalk_move_13",
		"night_stalker_nstalk_move_14"
	}

	Voices.lines["npc_kingdom_demon_melee"][VOICE_EVENT_ATTACK_UNIT] = {
		"night_stalker_nstalk_attack_01",
		"night_stalker_nstalk_attack_02",
		"night_stalker_nstalk_attack_03",
		"night_stalker_nstalk_attack_04",
		"night_stalker_nstalk_attack_05",
		"night_stalker_nstalk_attack_06",
		"night_stalker_nstalk_attack_07",
		"night_stalker_nstalk_attack_08",
		"night_stalker_nstalk_attack_09",
		"night_stalker_nstalk_attack_10",
		"night_stalker_nstalk_attack_11",
		"night_stalker_nstalk_attack_12",
		"night_stalker_nstalk_attack_13"
	}

	Voices.lines["npc_kingdom_demon_ranged"][VOICE_EVENT_SPAWN_UNIT] = {
		"shadow_demon_shadow_demon_spawn_01",
		"shadow_demon_shadow_demon_spawn_02",
		"shadow_demon_shadow_demon_spawn_03",
		"shadow_demon_shadow_demon_spawn_04",
		"shadow_demon_shadow_demon_spawn_05"
	}

	Voices.lines["npc_kingdom_demon_ranged"][VOICE_EVENT_MOVE_UNIT] = {
		"shadow_demon_shadow_demon_move_01",
		"shadow_demon_shadow_demon_move_02",
		"shadow_demon_shadow_demon_move_03",
		"shadow_demon_shadow_demon_move_04",
		"shadow_demon_shadow_demon_move_05",
		"shadow_demon_shadow_demon_move_06",
		"shadow_demon_shadow_demon_move_07",
		"shadow_demon_shadow_demon_move_08",
		"shadow_demon_shadow_demon_move_09",
		"shadow_demon_shadow_demon_move_10",
		"shadow_demon_shadow_demon_move_11",
		"shadow_demon_shadow_demon_move_12",
		"shadow_demon_shadow_demon_move_13",
		"shadow_demon_shadow_demon_move_14",
		"shadow_demon_shadow_demon_move_15",
		"shadow_demon_shadow_demon_move_16",
		"shadow_demon_shadow_demon_move_17",
		"shadow_demon_shadow_demon_move_18",
		"shadow_demon_shadow_demon_move_19",
		"shadow_demon_shadow_demon_move_20",
		"shadow_demon_shadow_demon_move_21",
		"shadow_demon_shadow_demon_move_22",
		"shadow_demon_shadow_demon_move_23",
		"shadow_demon_shadow_demon_move_24",
		"shadow_demon_shadow_demon_move_25",
		"shadow_demon_shadow_demon_move_26",
		"shadow_demon_shadow_demon_move_27",
		"shadow_demon_shadow_demon_move_28"
	}

	Voices.lines["npc_kingdom_demon_ranged"][VOICE_EVENT_ATTACK_UNIT] = {
		"shadow_demon_shadow_demon_attack_01",
		"shadow_demon_shadow_demon_attack_02",
		"shadow_demon_shadow_demon_attack_03",
		"shadow_demon_shadow_demon_attack_04",
		"shadow_demon_shadow_demon_attack_05",
		"shadow_demon_shadow_demon_attack_06",
		"shadow_demon_shadow_demon_attack_07",
		"shadow_demon_shadow_demon_attack_08",
		"shadow_demon_shadow_demon_attack_09",
		"shadow_demon_shadow_demon_attack_10",
		"shadow_demon_shadow_demon_attack_11",
		"shadow_demon_shadow_demon_attack_12",
		"shadow_demon_shadow_demon_attack_13",
		"shadow_demon_shadow_demon_attack_14"
	}

	Voices.lines["npc_kingdom_demon_cavalry"][VOICE_EVENT_SPAWN_UNIT] = {
		"chaos_knight_chaknight_spawn_01",
		"chaos_knight_chaknight_spawn_02",
		"chaos_knight_chaknight_spawn_03",
		"chaos_knight_chaknight_spawn_04",
		"chaos_knight_chaknight_spawn_05"
	}

	Voices.lines["npc_kingdom_demon_cavalry"][VOICE_EVENT_MOVE_UNIT] = {
		"chaos_knight_chaknight_move_01",
		"chaos_knight_chaknight_move_02",
		"chaos_knight_chaknight_move_03",
		"chaos_knight_chaknight_move_04",
		"chaos_knight_chaknight_move_05",
		"chaos_knight_chaknight_move_06",
		"chaos_knight_chaknight_move_07",
		"chaos_knight_chaknight_move_08",
		"chaos_knight_chaknight_move_09",
		"chaos_knight_chaknight_move_10",
		"chaos_knight_chaknight_move_11",
		"chaos_knight_chaknight_move_12",
		"chaos_knight_chaknight_move_13",
		"chaos_knight_chaknight_move_14",
		"chaos_knight_chaknight_move_15",
		"chaos_knight_chaknight_move_16",
		"chaos_knight_chaknight_move_17"
	}

	Voices.lines["npc_kingdom_demon_cavalry"][VOICE_EVENT_ATTACK_UNIT] = {
		"chaos_knight_chaknight_attack_01",
		"chaos_knight_chaknight_attack_02",
		"chaos_knight_chaknight_attack_03",
		"chaos_knight_chaknight_attack_04",
		"chaos_knight_chaknight_attack_05",
		"chaos_knight_chaknight_attack_06",
		"chaos_knight_chaknight_attack_07",
		"chaos_knight_chaknight_attack_08",
		"chaos_knight_chaknight_attack_09",
		"chaos_knight_chaknight_attack_10",
		"chaos_knight_chaknight_attack_11"
	}

	Voices.lines["npc_kingdom_hero_nevermore"][VOICE_EVENT_MOVE_UNIT] = {
		"nevermore_nev_move_01",
		"nevermore_nev_move_02",
		"nevermore_nev_move_03",
		"nevermore_nev_move_04",
		"nevermore_nev_move_05",
		"nevermore_nev_move_06",
		"nevermore_nev_move_07",
		"nevermore_nev_move_09",
		"nevermore_nev_move_10",
		"nevermore_nev_move_11",
		"nevermore_nev_move_12",
		"nevermore_nev_move_13",
		"nevermore_nev_move_14",
		"nevermore_nev_move_15"
	}

	Voices.lines["npc_kingdom_hero_nevermore"][VOICE_EVENT_ATTACK_UNIT] = {
		"nevermore_nev_attack_01",
		"nevermore_nev_attack_02",
		"nevermore_nev_attack_03",
		"nevermore_nev_attack_04",
		"nevermore_nev_attack_05",
		"nevermore_nev_attack_06",
		"nevermore_nev_attack_07",
		"nevermore_nev_attack_08",
		"nevermore_nev_attack_09",
		"nevermore_nev_attack_10",
		"nevermore_nev_attack_11",
		"nevermore_nev_attack_12"
	}

	Voices.lines["npc_kingdom_hero_duchess"][VOICE_EVENT_MOVE_UNIT] = {
		"queenofpain_pain_move_01",
		"queenofpain_pain_move_02",
		"queenofpain_pain_move_03",
		"queenofpain_pain_move_04",
		"queenofpain_pain_move_05",
		"queenofpain_pain_move_06",
		"queenofpain_pain_move_07",
		"queenofpain_pain_move_08",
		"queenofpain_pain_move_09",
		"queenofpain_pain_move_10",
		"queenofpain_pain_move_11",
		"queenofpain_pain_move_12",
		"queenofpain_pain_move_13"
	}

	Voices.lines["npc_kingdom_hero_duchess"][VOICE_EVENT_ATTACK_UNIT] = {
		"queenofpain_pain_attack_01",
		"queenofpain_pain_attack_02",
		"queenofpain_pain_attack_03",
		"queenofpain_pain_attack_04",
		"queenofpain_pain_attack_05",
		"queenofpain_pain_attack_06",
		"queenofpain_pain_attack_07",
		"queenofpain_pain_attack_08",
		"queenofpain_pain_attack_09",
		"queenofpain_pain_attack_10",
		"queenofpain_pain_attack_11",
		"queenofpain_pain_attack_12"
	}

	Voices.lines["npc_kingdom_hero_doom"][VOICE_EVENT_MOVE_UNIT] = {
		"doom_bringer_doom_move_01",
		"doom_bringer_doom_move_02",
		"doom_bringer_doom_move_03",
		"doom_bringer_doom_move_04",
		"doom_bringer_doom_move_05",
		"doom_bringer_doom_move_06",
		"doom_bringer_doom_move_07",
		"doom_bringer_doom_move_08",
		"doom_bringer_doom_move_09",
		"doom_bringer_doom_move_10",
		"doom_bringer_doom_move_11",
		"doom_bringer_doom_move_12"
	}

	Voices.lines["npc_kingdom_hero_doom"][VOICE_EVENT_ATTACK_UNIT] = {
		"doom_bringer_doom_attack_01",
		"doom_bringer_doom_attack_02",
		"doom_bringer_doom_attack_03",
		"doom_bringer_doom_attack_04",
		"doom_bringer_doom_attack_05",
		"doom_bringer_doom_attack_06",
		"doom_bringer_doom_attack_07",
		"doom_bringer_doom_attack_08",
		"doom_bringer_doom_attack_09",
		"doom_bringer_doom_attack_10"
	}

	Voices.lines["npc_kingdom_beast_2"][VOICE_EVENT_MOVE_UNIT] = {
		"centaur_cent_move_01",
		"centaur_cent_move_02",
		"centaur_cent_move_03",
		"centaur_cent_move_04",
		"centaur_cent_move_05",
		"centaur_cent_move_06",
		"centaur_cent_move_07",
		"centaur_cent_move_08",
		"centaur_cent_move_09",
		"centaur_cent_move_10",
		"centaur_cent_move_11",
		"centaur_cent_move_12",
		"centaur_cent_move_13",
		"centaur_cent_move_14",
		"centaur_cent_move_15",
		"centaur_cent_move_16",
		"centaur_cent_move_17",
		"centaur_cent_move_18",
		"centaur_cent_move_19",
		"centaur_cent_move_20",
		"centaur_cent_move_21",
		"centaur_cent_move_22"
	}

	Voices.lines["npc_kingdom_beast_2"][VOICE_EVENT_ATTACK_UNIT] = {
		"centaur_cent_attack_01",
		"centaur_cent_attack_02",
		"centaur_cent_attack_03",
		"centaur_cent_attack_04",
		"centaur_cent_attack_05",
		"centaur_cent_attack_06",
		"centaur_cent_attack_07",
		"centaur_cent_attack_08",
		"centaur_cent_attack_09",
		"centaur_cent_attack_10",
		"centaur_cent_attack_11"
	}

	Voices.lines["npc_kingdom_beast_5"][VOICE_EVENT_MOVE_UNIT] = {
		"ogre_magi_ogmag_move_01",
		"ogre_magi_ogmag_move_02",
		"ogre_magi_ogmag_move_03",
		"ogre_magi_ogmag_move_04",
		"ogre_magi_ogmag_move_05",
		"ogre_magi_ogmag_move_06",
		"ogre_magi_ogmag_move_07",
		"ogre_magi_ogmag_move_08",
		"ogre_magi_ogmag_move_09",
		"ogre_magi_ogmag_move_10",
		"ogre_magi_ogmag_move_11",
		"ogre_magi_ogmag_move_12",
		"ogre_magi_ogmag_move_13",
		"ogre_magi_ogmag_move_14",
		"ogre_magi_ogmag_move_15",
		"ogre_magi_ogmag_move_16",
		"ogre_magi_ogmag_move_17",
		"ogre_magi_ogmag_move_18",
		"ogre_magi_ogmag_move_19",
		"ogre_magi_ogmag_move_20",
		"ogre_magi_ogmag_move_21",
		"ogre_magi_ogmag_move_22",
		"ogre_magi_ogmag_move_23",
		"ogre_magi_ogmag_move_24"
	}

	Voices.lines["npc_kingdom_beast_5"][VOICE_EVENT_ATTACK_UNIT] = {
		"ogre_magi_ogmag_attack_01",
		"ogre_magi_ogmag_attack_02",
		"ogre_magi_ogmag_attack_03",
		"ogre_magi_ogmag_attack_04",
		"ogre_magi_ogmag_attack_05",
		"ogre_magi_ogmag_attack_06",
		"ogre_magi_ogmag_attack_07",
		"ogre_magi_ogmag_attack_08",
		"ogre_magi_ogmag_attack_09",
		"ogre_magi_ogmag_attack_10",
		"ogre_magi_ogmag_attack_11",
		"ogre_magi_ogmag_attack_12",
		"ogre_magi_ogmag_attack_13"
	}

	-- Last line time
	local time = GameRules:GetDOTATime(true, true)

	Voices.next_voice_time = {}

	Voices.next_voice_time[DOTA_TEAM_GOODGUYS] = time
	Voices.next_voice_time[DOTA_TEAM_BADGUYS] = time
	Voices.next_voice_time[DOTA_TEAM_CUSTOM_1] = time
	Voices.next_voice_time[DOTA_TEAM_CUSTOM_2] = time
	Voices.next_voice_time[DOTA_TEAM_CUSTOM_3] = time
	Voices.next_voice_time[DOTA_TEAM_CUSTOM_4] = time
	Voices.next_voice_time[DOTA_TEAM_CUSTOM_5] = time
	Voices.next_voice_time[DOTA_TEAM_CUSTOM_6] = time
end

function Voices:PlayLine(event, unit)
	local unit_name = unit:GetUnitName()
	if GameRules:GetDOTATime(true, true) > Voices.next_voice_time[unit:GetTeam()] and Voices.lines[unit_name] and Voices.lines[unit_name][event] then
		EmitAnnouncerSoundForTeam(Voices.lines[unit_name][event][RandomInt(1, #Voices.lines[unit_name][event])], unit:GetTeam())
		Voices.next_voice_time[unit:GetTeam()] = GameRules:GetDOTATime(true, true) + Voices.lines[event].cooldown
	end
end