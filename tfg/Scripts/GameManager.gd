extends Node

@onready var screenManager: ScreenManager = ScreenManager

var isDialogInScreen = false

func toSaveFilesScreen():
	get_tree().change_scene_to_file(screenManager.saveFilesScreen)

func toCreditsScreen():
	pass

func toOptionsScreen():
	pass

func QuitGame():
	get_tree().quit()


func setDialogState(newState: bool):
	isDialogInScreen = newState
