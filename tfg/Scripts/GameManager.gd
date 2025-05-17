extends Node



var isDialogInScreen = true

func toTutorialScreen():
	get_tree().change_scene_to_file(ScreenManager.tutorialScreen)

func toSaveFilesScreen():
	get_tree().change_scene_to_file(ScreenManager.saveFilesScreen)

func toCreditsScreen():
	pass

func toOptionsScreen():
	pass

func QuitGame():
	get_tree().quit()

func setDialogState(newState: bool):
	isDialogInScreen = newState

func inventoryOpen():
	get_tree().paused = true

func inventoryClosed():
	get_tree().paused = false
