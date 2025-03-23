extends Control

func _ready() -> void:
	
	var playButton: Button = $CharacterBody2D/Buttons/Play
	var optionButton: Button = $CharacterBody2D/Buttons/Options
	var creditsButton: Button = $CharacterBody2D/Buttons/Credits
	var quitButton: Button = $CharacterBody2D/Buttons/Quit


func onPlayButtonPressed():
	GameManager.toSaveFilesScreen()
	

func onOptionsButtonPressed():
	GameManager.toOptionsScreen()
	

func onCreditsButtonPressed():
	GameManager.toCreditsScreen()
	

func onQuitButtonPressed():
	GameManager.QuitGame()
	
