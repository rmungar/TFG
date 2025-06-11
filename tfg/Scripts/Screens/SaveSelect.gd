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
	$Slot0.getFocusableButton().grab_focus()
	pass

func updateSlotsUi():
	for i in range(1, 4):
		var label = slotButtons[i-1].get_node("NinePatchRect/Label")
		var playTimeText := ""
		if FileAccess.file_exists("user://gamefile%d.save" % i):
			var data = FileUtils.load_game(i)
			var tutorial_done = data.get("tutorialDone", false)
			var id := str(i)
			if GameManager.playerDataById.has(id):
				var time = GameManager.playerDataById[id].get("TotalPlayTime", 0.0)
				var hours = time / 60
				var minutes = int(time) % int(60)
				playTimeText = " | Playtime: %d:%02d" % [hours, minutes]
			label.text = "Tutorial: %s%s" % ["✔️" if tutorial_done else "❌", playTimeText]
		else:
			label.text = "Empty"
			var textureButton: TextureButton = slotButtons[i-1].get_node("NinePatchRect/PlayButton")
			textureButton.texture_normal = NewGameTextureNoBG
			textureButton.texture_pressed = NewGameTextureBG
			textureButton.texture_hover = NewGameTextureBG
			textureButton.texture_focused = NewGameTextureBG
	GameManager.hasLoadedGame = false


func _on_wants_to_delete(saveFileNumber: int) -> void:
	var path = "user://gamefile%d.save" % saveFileNumber
	if FileAccess.file_exists(path):
		var dir := DirAccess.open("user://")
		if dir:
			dir.remove("gamefile%d.save" % saveFileNumber)
			ApiHelper.delete_player(saveFileNumber)
		else:
			push_error("No se pudo abrir el directorio para borrar.")
		updateSlotsUi()


func _on_wants_to_play(saveFileNumber: int) -> void:
	GameManager.currentSaveFile = saveFileNumber
	GameManager.isLoadingGame = true
	GameManager.isInMainMenu = false
	var data = FileUtils.load_game(saveFileNumber)
	var tutorial_done = data.get("tutorialDone", false)
	GameManager.talkedToIsilian = data.get("spokenToIsilian", false)
	GameManager.talkedToMerchant = data.get("spokenToMerchant", false)
	var sceneToLoad := "res://Scenes/Screens/WorldMap.tscn" if tutorial_done else "res://Scenes/Screens/TutorialScreen.tscn"
	
	if !GameManager.playerDataById.has(str(saveFileNumber)):
		ApiHelper.create_player()
	
	GameManager.counting = true
	var loadingScreen = load("res://Scenes/Screens/LoadingScreen.tscn").instantiate()
	loadingScreen.targetScene = sceneToLoad
	get_tree().root.add_child(loadingScreen)
	get_tree().current_scene.queue_free()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
