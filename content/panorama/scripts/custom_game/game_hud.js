var top_message_count = 0;
var capital_warning_visible = false;
var income_detail_toggle = false;
var last_timer = 0;
var last_turn_started = false;
var income_details_full = {};
var income_details_half = {};

income_details_full[1] = false;
income_details_full[2] = false;
income_details_full[3] = false;
income_details_full[4] = false;
income_details_full[5] = false;
income_details_full[6] = false;
income_details_full[7] = false;
income_details_full[8] = false;

income_details_half[1] = false;
income_details_half[2] = false;
income_details_half[3] = false;
income_details_half[4] = false;
income_details_half[5] = false;
income_details_half[6] = false;
income_details_half[7] = false;
income_details_half[8] = false;

(function () {
	InitializeUI()

	CustomUIThink()

	CustomNetTables.SubscribeNetTableListener("player_info", UpdateIncomeScoreboard);
	CustomNetTables.SubscribeNetTableListener("region_info", UpdateIncomeDetails);

	GameEvents.Subscribe("kingdom_select_all_units", SelectAllUnits);
	GameEvents.Subscribe("kingdom_minimap_ping", MinimapPing);
	GameEvents.Subscribe("kingdom_turn_ended", PopIncomeDetail);

	GameEvents.Subscribe("kingdom_hero_recruited", ShowMessageHeroRecruited);
	GameEvents.Subscribe("kingdom_hero_killed", ShowMessageHeroKilled);

	GameEvents.Subscribe("kingdom_new_region_sovereign", ShowMessageNewRegionSovereign);
	GameEvents.Subscribe("kingdom_new_region_contender", ShowMessageNewRegionContender);
	GameEvents.Subscribe("kingdom_lost_region_sovereign", ShowMessageLostRegionSovereign);
	GameEvents.Subscribe("kingdom_lost_region_contender", ShowMessageLostRegionContender);

	GameEvents.Subscribe("kingdom_player_eliminated", ShowMessageEliminated);
	GameEvents.Subscribe("kingdom_player_near_win", ShowMessageNearWin);
	GameEvents.Subscribe("kingdom_player_very_near_win", ShowMessageVeryNearWin);
	GameEvents.Subscribe("kingdom_announce_discord", ShowDiscordMessage);

	GameEvents.Subscribe("kingdom_capital_choice_phase", ShowCapitalWarning);
	GameEvents.Subscribe("kingdom_capital_chosen", ShowMessageCapitalChosen);
})();

function InitializeUI() {
	FindDotaHudElement("ToggleScoreboardButton").style.visibility = 'collapse';
	FindDotaHudElement("inventory_tpscroll_container").style.visibility = 'collapse';
	FindDotaHudElement("inventory_neutral_slot_container").style.visibility = 'collapse';

	var current_row = 1;
	for (var id = 0; id <= 7; id++) {
		if(Players.IsValidPlayerID(id)) {
			var player_steam_id = CustomNetTables.GetTableValue("player_info", "player_steam_id_" + id).player_steam_id
			$('#income_player_avatar_player_' + current_row).steamid = player_steam_id
			//$('#income_player_label_player_' + current_row).steamid = player_steam_id
			$('#income_player_container_' + current_row).style["background-color"] = ColorToHexCode(Players.GetPlayerColor(id)) + "88";
			current_row = current_row + 1;
		} else {
			$('#income_player_container_' + current_row).style.visibility = 'collapse';
			current_row = current_row + 1;
		}
	}
}

function IncomeDetail() {
	if (income_detail_toggle) {
		income_detail_toggle = false
		$('#income_detail_button').style['background-image'] = 'url("s2r://panorama/images/control_icons/arrow_dropdown_png.vtex")';
		$('#income_detail_container').style.width = '0px';
	} else {
		income_detail_toggle = true
		$('#income_detail_button').style['background-image'] = 'url("s2r://panorama/images/control_icons/arrow_dropdown_up_png.vtex")';
		$('#income_detail_container').style.width = '350px';
	}
}

function PopIncomeDetail() {
	if (!income_detail_toggle) {
		IncomeDetail();
		$.Schedule(4.0, UnPopIncomeDetail);
	}
}

function UnPopIncomeDetail() {
	if (income_detail_toggle) {
		IncomeDetail();
	}
}

function UpdateIncomeScoreboard(keys) {

	var local_player_id = Players.GetLocalPlayer()
	var timer = CustomNetTables.GetTableValue(keys, "turn_timer").turn_timer
	var turn_state = CustomNetTables.GetTableValue(keys, "turn_state").turn_state
	$('#income_timer_label').text = timer + "s";
	$('#gold_amount_label').text = Players.GetGold(Players.GetLocalPlayer())

	// Time-specific logic
	if (timer <= 3) {
		$('#income_timer_label').style.color = '#FF4040FF'
		if (timer != last_timer) {
			Game.EmitSound("General.CastFail_AbilityInCooldown")
		}
	} else {
		$('#income_timer_label').style.color = '#FFFFFFFF'
	}

	last_timer = timer;

	// Last turn logic
	if (turn_state == "last_turn") {
		$('#income_timer_label').text = $.Localize("#last_turn_warning") + timer + "s";

		if(!last_turn_started) {
			last_turn_started = true;

			Game.EmitSound("MegaCreeps.Radiant");

			$('#income_description_container').RemoveAndDeleteChildren();

			$('#income_container').style.width = "900px";
			$('#income_container').style.height = "60px";
			$('#income_container').style["horizontal-align"] = "center;";
			$('#income_container').style["vertical-align"] = "bottom;";
			$('#income_container').style["margin-top"] = "0px;";
			$('#income_container').style["margin-bottom"] = "145px;";

			$('#income_timer_container').style.width = "100%";
			$('#income_timer_container').style["margin-left"] = "0px";
		}
	}

	if (turn_state == "overtime") {
		$('#income_timer_label').text = $.Localize("#overtime_warning");
	}

	var current_row = 1;
	for (var id = 0; id <= 7; id++) {
		if(Players.IsValidPlayerID(id)) {
			var player_income = Math.floor("+" + CustomNetTables.GetTableValue("player_info", "player_" + id).income)
			$('#income_player_label_income_' + current_row).text = "+" + player_income
			$('#income_player_label_cities_' + current_row).text = CustomNetTables.GetTableValue("player_info", "player_cities_" + id).city_amount
			$('#income_player_label_player_' + current_row).text = CustomNetTables.GetTableValue("player_info", "player_name_" + id).player_name
			current_row = current_row + 1;
		}
	}

	var local_player_income = Math.floor(CustomNetTables.GetTableValue(keys, "player_" + local_player_id).income)
	$('#income_amount_label').text = "+" + local_player_income;
}

function UpdateIncomeDetails(keys) {

	var player_id = Players.GetLocalPlayer()
	var parent_full = $('#income_detail_full_container')
	var parent_half = $('#income_detail_half_container')
	var region_info = CustomNetTables.GetTableValue(keys, "region_owners")

	for (var region = 1; region <= 8; region++) {
		if (region_info.owners[player_id][region] == 1) {
			if (!income_details_full[region]) {
				income_details_full[region] = true;

				var container = $.CreatePanel("Panel", parent_full, "income_detail_" + region + "_full");
				container.AddClass("income_detail_row_full")
				var label = $.CreatePanel("Label", container, "income_detail_label_" + region + "_full");
				label.AddClass("income_detail_label_full")
				label.text = $.Localize("#regional_bonus_full_" + region)

				PopIncomeDetail();
			}

			if ( (region == 3 || region == 4 || region == 7 || region == 8) && income_details_half[region] ) {
				income_details_half[region] = false;
				$("#income_detail_" + region + "_half").RemoveAndDeleteChildren()
			}
		} else {
			if (income_details_full[region]) {
				income_details_full[region] = false;
				$("#income_detail_" + region + "_full").RemoveAndDeleteChildren()

				PopIncomeDetail();
			}
		}

		if (region_info.contenders[player_id][region] == 1) {
			if (region == 3 || region == 4 || region == 7 || region == 8) {
				if (region_info.owners[player_id][region] == 0 && !income_details_half[region]) {
					income_details_half[region] = true;

					var container = $.CreatePanel("Panel", parent_half, "income_detail_" + region + "_half");
					container.AddClass("income_detail_row_half")
					var label = $.CreatePanel("Label", container, "income_detail_label_" + region + "_half");
					label.AddClass("income_detail_label_half")
					label.text = $.Localize("#regional_bonus_half_" + region)

					PopIncomeDetail();
				}
			} else {
				if(!income_details_half[region]) {
					income_details_half[region] = true;

					var container = $.CreatePanel("Panel", parent_half, "income_detail_" + region + "_half");
					container.AddClass("income_detail_row_half")
					var label = $.CreatePanel("Label", container, "income_detail_label_" + region + "_half");
					label.AddClass("income_detail_label_half")
					label.text = $.Localize("#regional_bonus_half_" + region)

					PopIncomeDetail();
				}
			}
		} else {
			if (income_details_half[region]) {
				income_details_half[region] = false;
				$("#income_detail_" + region + "_half").RemoveAndDeleteChildren()

				PopIncomeDetail();
			}
		}
	}
}

function SelectAllUnits() {
	var all_entities = Entities.GetAllEntities()
	var local_team = Players.GetTeam(Game.GetLocalPlayerID())
	var started_selection = false

	GameUI.SelectUnit(null, false)

	for (var entity_index in all_entities) {
		if (Entities.GetTeamNumber(all_entities[entity_index]) == local_team && !Entities.IsInvulnerable(all_entities[entity_index])) {
			GameUI.SelectUnit(all_entities[entity_index], started_selection)
			started_selection = true
		}
	}
}

function CustomUIThink() {
	var selected_entities = Players.GetSelectedEntities(Players.GetLocalPlayer())
	var need_update = false;

	for (var entity_index in selected_entities) {
		if (Entities.IsInvulnerable(selected_entities[entity_index])) {
			need_update = true;
			break;
		}
	}

	if (need_update && selected_entities.length > 1) {
		var started_selection = false
		for (var entity_index in selected_entities) {
			if (!Entities.IsInvulnerable(selected_entities[entity_index])) {
				GameUI.SelectUnit(selected_entities[entity_index], started_selection)
				started_selection = true
			}
		}	
	}

	$.Schedule(0.1, CustomUIThink)
}

function MinimapPing(keys) {
	GameUI.PingMinimapAtLocation([keys.x, keys.y, keys.z])
}

function ShowCapitalWarning(keys) {
	if (capital_warning_visible) {
		if (keys["1"].time > 0) {
			$('#message_2_timer').text = keys["1"].time
			if (keys["1"].time == 10) {
				Game.EmitSound("MegaCreeps.Dire")
				$('#message_2_timer').style.color = '#FFFF40FF'
			} else if (keys["1"].time <= 5) {
				Game.EmitSound("General.CastFail_AbilityInCooldown")
				$('#message_2_timer').style.color = '#FF4040FF'
			} else {
				Game.EmitSound("ui_select_md")
			}
		} else {
			Game.EmitSound("Game.Start")
			$('#message_2_timer').style.visibility = 'collapse'
			$('#message_1_label').text = $.Localize("#pick_capital_random")
			$('#message_2_label').text = $.Localize("#pick_capital_start")

			$.Schedule(5, function() {
				$('#bottom_message_feed_container').style.height = '0px';
				$.Schedule(1, function() {
					$('#bottom_message_feed_container').RemoveAndDeleteChildren()
				})
			})
		}
	} else {
		capital_warning_visible = true

		var message_feed_container = $('#bottom_message_feed_container')

		$('#bottom_message_feed_container').style["border-top"] = "2px solid #111111FF"
		$('#bottom_message_feed_container').style["border-bottom"] = "2px solid #111111FF"

		var message_1_background = $.CreatePanel("Panel", message_feed_container, "message_background");
		var message_1_container = $.CreatePanel("Panel", message_1_background, "message_container");
		var message_1_label = $.CreatePanel("Label", message_1_container, "message_1_label");

		message_1_background.AddClass("bottom_message_background")
		message_1_container.AddClass("bottom_message_container")
		message_1_label.AddClass("bottom_message_label")

		message_1_label.text = $.Localize("#pick_capital")

		var message_2_background = $.CreatePanel("Panel", message_feed_container, "message_background");
		var message_2_container = $.CreatePanel("Panel", message_2_background, "message_container");
		var message_2_timer = $.CreatePanel("Label", message_2_container, "message_2_timer");
		var message_2_label = $.CreatePanel("Label", message_2_container, "message_2_label");

		message_2_background.AddClass("bottom_message_background")
		message_2_container.AddClass("bottom_message_container")
		message_2_label.AddClass("bottom_message_label")
		message_2_timer.AddClass("bottom_message_label")

		message_feed_container.style.height = '84px'
		message_2_label.text = $.Localize("#pick_capital_time")
		message_2_timer.text = keys["1"].time
	}
}

function UpdateTopMessageFeedBorder() {
	if (top_message_count > 0) {
		$('#top_message_feed_container').style["border-top"] = "2px solid #111111FF"
		$('#top_message_feed_container').style["border-bottom"] = "2px solid #111111FF"
	} else {
		$('#top_message_feed_container').style["border-top"] = "0px"
		$('#top_message_feed_container').style["border-bottom"] = "0px"
	}
}

function ShowMessageCapitalChosen(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#capital_picked_1") + $.Localize(data.cityname) + $.Localize("#capital_picked_2") + "!"
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageHeroRecruited(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_player_name = $.CreatePanel("Label", message_container, "message_player_name");
	var message_hero_icon = $.CreatePanel("DOTAHeroImage", message_container, "message_hero_icon");
	var message_hero_name = $.CreatePanel("Label", message_container, "message_hero_name");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_player_name.AddClass("top_message_label")
	message_hero_icon.AddClass("top_message_hero_image")
	message_hero_name.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_player_name.text = data.playername + $.Localize("#has_recruited")
	message_hero_icon.heroname = data.heroname
	message_hero_icon.heroimagestyle = 'icon'
	message_hero_name.text = $.Localize("#" + data.unitname) + "!"
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageHeroKilled(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_player_name = $.CreatePanel("Label", message_container, "message_player_name");
	var message_hero_icon = $.CreatePanel("DOTAHeroImage", message_container, "message_hero_icon");
	var message_hero_name = $.CreatePanel("Label", message_container, "message_hero_name");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_player_name.AddClass("top_message_label")
	message_hero_icon.AddClass("top_message_hero_image")
	message_hero_name.AddClass("top_message_label")

	var data = keys["1"]

	if (Players.IsValidPlayerID(data.playerid)) {
		message_player_avatar.steamid = data.steamid
		message_player_name.text = data.playername + "'s "
		message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	} else {
		message_player_avatar.style.visibility = 'collapse';
		message_player_name.text = ""
		message_background.style["background-color"] = '#00000070';
	}

	message_hero_icon.heroname = data.heroname
	message_hero_icon.heroimagestyle = 'icon'
	message_hero_name.text = $.Localize("#" + data.unitname) + $.Localize("#has_been_killed")
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageNewRegionSovereign(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#region_new_sovereign_1") + $.Localize(data.regionname) + $.Localize("#region_new_sovereign_2")
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageNewRegionContender(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#region_new_contender_1") + $.Localize(data.regionname) + $.Localize("#region_new_contender_2")
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageLostRegionSovereign(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#region_lost_sovereign") + $.Localize(data.regionname) + "!"
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageLostRegionContender(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#region_lost_contender") + $.Localize(data.regionname) + "!"
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageEliminated(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#player_eliminated") + data.position + $.Localize("#endgame_position_post");
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageNearWin(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_player_avatar = $.CreatePanel("DOTAAvatarImage", message_container, "message_player_avatar");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_player_avatar.steamid = data.steamid
	message_body.text = data.playername + $.Localize("#player_near_win");
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	message_player_avatar.AddClass("top_message_player_avatar")

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowMessageVeryNearWin(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_body.text = data.playername + $.Localize("#player_very_near_win");
	message_background.style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

function ShowDiscordMessage(keys) {
	var message_feed_container = $('#top_message_feed_container')

	var message_background = $.CreatePanel("Panel", message_feed_container, "message_background");
	var message_container = $.CreatePanel("Panel", message_background, "message_container");
	var message_body = $.CreatePanel("Label", message_container, "message_body");

	message_background.AddClass("top_message_background")
	message_container.AddClass("top_message_container")
	message_body.AddClass("top_message_label")

	var data = keys["1"]

	message_body.text = $.Localize("#visit_discord");
	message_background.style["background-color"] = "#0070FF70";

	top_message_count = top_message_count + 1
	UpdateTopMessageFeedBorder()

	$.Schedule(6, function() {
		message_background.style.height = '0px';
		$.Schedule(1, function() {
			message_background.RemoveAndDeleteChildren()
			top_message_count = top_message_count - 1
			UpdateTopMessageFeedBorder();
		})
	})
}

// Utility functions
function FindDotaHudElement (id) {
	return GetDotaHud().FindChildTraverse(id);
}

function GetDotaHud () {
	var p = $.GetContextPanel();
	while (p !== null && p.id !== 'Hud') {
		p = p.GetParent();
	}
	if (p === null) {
		throw new HudNotFoundException('Could not find Hud root as parent of panel with id: ' + $.GetContextPanel().id);
	} else {
		return p;
	}
}

function ColorToHexCode(color) {
	var red = (color & 0xff).toString(16);
	var green = ((color & 0xff00) >> 8).toString(16);
	var blue = ((color & 0xff0000) >> 16).toString(16);
	if (red == "0") {
		red = "00"
	}
	if (green == "0") {
		green = "00"
	}
	if (blue == "0") {
		blue = "00"
	}
	return '#' + red + green + blue;
}