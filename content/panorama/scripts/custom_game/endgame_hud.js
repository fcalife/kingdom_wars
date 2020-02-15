(function () {
	GameEvents.Subscribe("kingdom_winner", UpdateWinner);
})();

function UpdateWinner(keys) {
	$('#endgame_winner_avatar').steamid = keys["1"].steamid;
	$('#endgame_winner_name').steamid = keys["1"].steamid;
	$('#endgame_container').style.opacity = 1;
}