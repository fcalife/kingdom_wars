(function () {
	InitializeUI()

	CustomUIThink()

	CustomNetTables.SubscribeNetTableListener("player_info", UpdateIncomeScoreboard);

	GameEvents.Subscribe("kingdom_minimap_ping", MinimapPing);

	GameEvents.Subscribe("kingdom_hero_recruited", ShowMessageHeroRecruited);

	GameEvents.Subscribe("kingdom_hero_killed", ShowMessageHeroKilled);
})();

function InitializeUI() {
	FindDotaHudElement("ToggleScoreboardButton").style.visibility = 'collapse';
	FindDotaHudElement("inventory_tpscroll_container").style.visibility = 'collapse';

	var current_row = 1;
	for (var id = 0; id <= 7; id++) {
		if(Players.IsValidPlayerID(id)) {
			var player_steam_id = CustomNetTables.GetTableValue("player_info", "player_steam_id_" + id).player_steam_id
			$('#income_player_avatar_player_' + current_row).steamid = player_steam_id
			$('#income_player_label_player_' + current_row).steamid = player_steam_id
			$('#income_player_container_' + current_row).style["background-color"] = ColorToHexCode(Players.GetPlayerColor(id)) + "70";
			//$('#income_player_label_player_' + current_row).style.color = ColorToHexCode(Players.GetPlayerColor(id)) + "ff";
			current_row = current_row + 1;
		} else {
			$('#income_player_container_' + current_row).style.visibility = 'collapse';
			current_row = current_row + 1;
		}
	}
}

function UpdateIncomeScoreboard(keys) {

	var local_player_id = Players.GetLocalPlayer()
	var local_player_income = Math.floor(CustomNetTables.GetTableValue(keys, "player_" + local_player_id).income)
	$('#income_timer_label').text = CustomNetTables.GetTableValue(keys, "turn_timer").turn_timer + "s";
	$('#income_amount_label').text = "+" + local_player_income;
	$('#gold_amount_label').text = Players.GetGold(Players.GetLocalPlayer())

	var current_row = 1;
	for (var id = 0; id <= 7; id++) {
		if(Players.IsValidPlayerID(id)) {
			var player_income = Math.floor("+" + CustomNetTables.GetTableValue("player_info", "player_" + id).income)
			$('#income_player_label_income_' + current_row).text = "+" + player_income
			$('#income_player_label_cities_' + current_row).text = CustomNetTables.GetTableValue("player_info", "player_cities_" + id).city_amount
			current_row = current_row + 1;
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

function ShowMessageHeroRecruited(keys) {
	$('#main_message_player_avatar').style.visibility = 'visible';

	var data = keys["1"]

	$('#main_message_player_avatar').steamid = data.steamid
	$('#main_message_pre_label').text = data.playername + $.Localize("#has_recruited")
	$('#main_message_hero_image').heroname = data.heroname
	$('#main_message_post_label').text = $.Localize("#" + data.unitname) + "!"
	$('#main_message_container').style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	$('#main_message_container').style.opacity = 1;
	$.Schedule(2.5, HideMainMessage)
}

function ShowMessageHeroKilled(keys) {
	$('#main_message_player_avatar').style.visibility = 'visible';

	var data = keys["1"]

	if (Players.IsValidPlayerID(data.playerid)) {
		$('#main_message_player_avatar').steamid = data.steamid
		$('#main_message_pre_label').text = data.playername + "'s "
		$('#main_message_container').style["background-color"] = ColorToHexCode(Players.GetPlayerColor(data.playerid)) + "70";
	} else {
		$('#main_message_player_avatar').style.visibility = 'collapse';
		$('#main_message_pre_label').text = ""
		$('#main_message_container').style["background-color"] = '#00000070';
	}

	$('#main_message_hero_image').heroname = data.heroname
	$('#main_message_post_label').text = $.Localize("#" + data.unitname) + $.Localize("#has_been_killed")
	$('#main_message_container').style.opacity = 1;
	$.Schedule(2.5, HideMainMessage)
}

function HideMainMessage() {
	$('#main_message_container').style.opacity = 0;
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