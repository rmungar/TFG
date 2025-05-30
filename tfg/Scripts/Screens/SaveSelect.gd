extends Control

@onready var slotButtons := [$Slot0, $Slot1, $Slot2]

var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")
var current_input_mode := InputMode.MOUSE
enum InputMode { MOUSE, GAMEPAD }
@export var gamepad_speed: float = 500.0


@onready var NewGameTextureBG = preload("res://Assets/UI/UI - Words/Words With BG/UI - Words2.png")
@onready var NewGameTextureNoBG = preload("res://Assets/UI/UI - Words/Words without BG/UI - Words2.png")


func _ready():
	updateSlotsUi()
	pass



func updateSlotsUi():
	for i in range(1,4):
		if FileAccess.file_exists("user://gamefile%d.save" % i):
			var data = FileUtils.load_game(i)
			var tutorial_done = data.get("tutorialDone", false)
			if tutorial_done:
				pass
			else:
				pass
			slotButtons[i-1].get_node("NinePatchRect").get_node("Label").text = "Partida %d - Tutorial: %s" % [i + 1, "✔" if tutorial_done else "❌"]
		else:
			slotButtons[i-1].get_node("NinePatchRect").get_node("Label").text = "Empty"
			var textureButton: TextureButton = slotButtons[i-1].get_node("NinePatchRect").get_node("PlayButton")
			textureButton.texture_normal = NewGameTextureNoBG
			textureButton.texture_pressed = NewGameTextureBG
			textureButton.texture_hover = NewGameTextureBG
			textureButton.texture_focused = NewGameTextureNoBG



func _on_slot_pressed(slot_index: int):
	GameManager.currentSaveFile = slot_index
	GameManager.isLoadingGame = true
	get_tree().change_scene_to_file("res://scenes/World.tscn") 



func _on_wants_to_delete(saveFileNumber: int) -> void:
	var path = "user://gamefile%d.save" % saveFileNumber
	if FileAccess.file_exists(path):
		var dir := DirAccess.open("user://")
		if dir:
			dir.remove("gamefile%d.save" % saveFileNumber)
			print("Partida %d borrada" % saveFileNumber)
		else:
			push_error("No se pudo abrir el directorio para borrar.")
		updateSlotsUi()
	else:
		print("No hay partida para borrar en slot %d" % saveFileNumber)


func _on_wants_to_play(saveFileNumber: int) -> void:
	GameManager.currentSaveFile = saveFileNumber
	GameManager.isLoadingGame = true
	
	var data = FileUtils.load_game(saveFileNumber)
	var tutorial_done = data.get("tutorialDone", false)
	
	var sceneToLoad := "res://Scenes/Screens/World.tscn" if tutorial_done else "res://Scenes/Screens/TutorialScreen.tscn"
	
	var loadingScreen = load("res://Scenes/Screens/LoadingScreen.tscn").instantiate()
	loadingScreen.targetScene = sceneToLoad
	get_tree().root.add_child(loadingScreen)
	get_tree().current_scene.queue_free()
