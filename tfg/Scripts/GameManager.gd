extends Node

var isLoadingGame = false
var hasLoadedGame = false
var isDialogInScreen = false
var isInventoryOpen = false
var currentSaveFile: int = 1
var temporalPlayerData: Dictionary
var tutorial_done: bool = false
var isShopInScreen: bool = false
var talkedToMerchant: bool = false
var talkedToIsilian: bool = false



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


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
	print(Input.mouse_mode)
	isDialogInScreen = newState
	if isDialogInScreen:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func setShopInScreenState(newState: bool):
	isShopInScreen = newState


func inventoryOpen():
	isInventoryOpen = true
	get_tree().paused = true


func inventoryClosed():
	isInventoryOpen = false
	get_tree().paused = false


func onSave(player: Player, tutorialDone: bool):
	FileUtils.save_game(currentSaveFile, player, tutorialDone, talkedToMerchant, talkedToIsilian)
