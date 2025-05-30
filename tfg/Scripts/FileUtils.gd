extends Node


func save_game(save_file: int, player: Player, tutorial_done: bool):
	var path := "user://gamefile" + str(save_file) + ".save"
	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("No se pudo abrir el archivo.")
		return

	var data := {
		"HP": player.HP,
		"canHeal": player.canHeal,
		"canAttack": player.canAttack,
		"lastCheckPoint": player.lastCheckPoint,
		"money": player.money,
		"inventory": player.inventory.serialize(),  
		"tutorialDone": tutorial_done
	}
	file.store_line(JSON.stringify(data, "\t"))
	file.close()

func load_game(save_file: int) -> Dictionary:
	var path := "user://gamefile" + str(save_file) + ".save"
	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("No se pudo abrir el archivo.")
		return {}

	return JSON.parse_string(file.get_line())
