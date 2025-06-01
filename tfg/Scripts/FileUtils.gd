extends Node



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func save_game(save_file: int, player: Player, tutorial_done: bool):
	var path := "user://gamefile" + str(save_file) + ".save"
	var file := FileAccess.open(path, FileAccess.WRITE)
	
	if FileAccess.get_open_error() != OK:
		push_error("Error al abrir o crear el archivo de guardado.")
		return
	
	var data := {
		"HP": player.HP,
		"canHeal": player.canHeal,
		"canAttack": player.canAttack,
		"lastCheckPoint": player.lastCheckPoint,
		"lastTileMap": player.lastTilemap,
		"money": player.money,
		"inventory": player.inventory.serialize(),  
		"tutorialDone": tutorial_done
	}
	file.store_line(JSON.stringify(data))
	file.close()

func load_game(save_file: int) -> Dictionary:
	var path := "user://gamefile" + str(save_file) + ".save"
	if not FileAccess.file_exists(path):
		push_error("Archivo de guardado no encontrado: " + path)
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("No se pudo abrir el archivo: " + path)
		return {}
	var line = file.get_line()
	file.close()
	var result = JSON.parse_string(line)
	if result is Dictionary and result.has("HP") and result.has("inventory"):
		GameManager.hasLoadedGame = true
		return result
	else:
		push_error("Error al parsear el archivo de guardado.")
		return {}
