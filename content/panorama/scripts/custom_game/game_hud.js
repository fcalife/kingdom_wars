(function () {
	InitializeUI()

	CustomNetTables.SubscribeNetTableListener("player_info", UpdateIncomeScoreboard);
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