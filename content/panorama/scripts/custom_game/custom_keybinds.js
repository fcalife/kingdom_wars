var control_groups = {}
for (var i = 1; i <= 11; i++) {
	control_groups[i] = {}
}

(function () {
	RegisterKeybinds()
})();

function RegisterKeybinds() {
	Game.CreateCustomKeyBind("1", "ControlGroup1");
	Game.CreateCustomKeyBind("2", "ControlGroup2");
	Game.CreateCustomKeyBind("3", "ControlGroup3");
	Game.CreateCustomKeyBind("4", "ControlGroup4");
	Game.CreateCustomKeyBind("5", "ControlGroup5");
	Game.CreateCustomKeyBind("6", "ControlGroup6");
	Game.CreateCustomKeyBind("7", "ControlGroup7");
	Game.CreateCustomKeyBind("8", "ControlGroup8");
	Game.CreateCustomKeyBind("9", "ControlGroup9");
	Game.CreateCustomKeyBind("0", "ControlGroup10");
	Game.AddCommand("ControlGroup1", ControlGroup1, "", 0);
	Game.AddCommand("ControlGroup2", ControlGroup2, "", 0);
	Game.AddCommand("ControlGroup3", ControlGroup3, "", 0);
	Game.AddCommand("ControlGroup4", ControlGroup4, "", 0);
	Game.AddCommand("ControlGroup5", ControlGroup5, "", 0);
	Game.AddCommand("ControlGroup6", ControlGroup6, "", 0);
	Game.AddCommand("ControlGroup7", ControlGroup7, "", 0);
	Game.AddCommand("ControlGroup8", ControlGroup8, "", 0);
	Game.AddCommand("ControlGroup9", ControlGroup9, "", 0);
	Game.AddCommand("ControlGroup10", ControlGroup10, "", 0);
}

function ControlGroup(key) {
	if (GameUI.IsControlDown()) {
		control_groups[key] = Players.GetSelectedEntities(Players.GetLocalPlayer())
	} else {
		var selection_size = control_groups[key].length
		if (Entities.IsAlive(control_groups[key][0])) {
			GameUI.SelectUnit(control_groups[key][0], false)
		}

		for (var i = 1; i < selection_size; i++) {
			if (Entities.IsAlive(control_groups[key][i])) {
				GameUI.SelectUnit(control_groups[key][i], true)
			}
		}
	}
}

function ControlGroup1()	{	ControlGroup(1)	}
function ControlGroup2()	{	ControlGroup(2)	}
function ControlGroup3()	{	ControlGroup(3)	}
function ControlGroup4()	{	ControlGroup(4)	}
function ControlGroup5()	{	ControlGroup(5)	}
function ControlGroup6()	{	ControlGroup(6)	}
function ControlGroup7()	{	ControlGroup(7)	}
function ControlGroup8()	{	ControlGroup(8)	}
function ControlGroup9()	{	ControlGroup(9)	}
function ControlGroup10()	{	ControlGroup(0)	}

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