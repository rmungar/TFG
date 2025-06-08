extends Node

var isLoadingGame = false
var hasLoadedGame = false
var isDialogInScreen = false
var pauseMenuOpen = false
var isInventoryOpen = false
var currentSaveFile: int = 1
var temporalPlayerData: Dictionary
var tutorial_done: bool = false
var isShopInScreen: bool = false
var talkedToMerchant: bool = false
var talkedToIsilian: bool = false
var counting: bool = false
var totalPlayTime: float = 0.0
var playerDataById: Dictionary = {}
var bossDefeated: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	ApiHelper.connect("requestCompleted", onApiResponse)
	ApiHelper.get_all_players()


func _process(delta: float) -> void:
	if counting:
		totalPlayTime += delta

func toTutorialScreen():
	get_tree().change_scene_to_file(ScreenManager.tutorialScreen)
	

func toSaveFilesScreen():
	get_tree().change_scene_to_file(ScreenManager.saveFilesScreen)


func toOptionsScreen():
	pass


func QuitGame():
	get_tree().quit()


func setDialogState(newState: bool):
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
	if GameManager.playerDataById.has(str(GameManager.currentSaveFile)):
		ApiHelper.update_player()
	else: 
		ApiHelper.create_player()
	ApiHelper.get_all_players()


func onApiResponse(result: bool, body):
	if result and body is Array:
		playerDataById.clear()
		for player in body:
			var id = player.get("PlayerId", null)
			if id != null:
				playerDataById[id] = player
	else:
		if result:
			ApiHelper.get_all_players()



func formatPlayTime():
	var minutes = int(totalPlayTime) / 60
	var seconds = int(totalPlayTime) % 60
	return "%02d:%02d" % [minutes, seconds]
