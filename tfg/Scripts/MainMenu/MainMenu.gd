extends Control

@onready var playButton: TextureButton = $CharacterBody2D/Buttons/Play
@onready var continueButton: TextureButton = $CharacterBody2D/Buttons/Continue
@onready var optionsButton: TextureButton = $CharacterBody2D/Buttons/Options
@onready var creditsButton: TextureButton = $CharacterBody2D/Buttons/Credits
@onready var quitButton: TextureButton = $CharacterBody2D/Buttons/Quit



func _ready() -> void:
	
	if playButton.disabled:
		playButton.visible = false
	if continueButton.disabled:
		continueButton.visible = false
	if optionsButton.disabled:
		optionsButton.visible = false
	if creditsButton.disabled:
		creditsButton.visible = false
	if quitButton.disabled:
		quitButton.visible = false



func onPlayButtonPressed():
	GameManager.toTutorialScreen()
	

func onOptionsButtonPressed():
	GameManager.toOptionsScreen()
	

func onCreditsButtonPressed():
	GameManager.toCreditsScreen()
	

func onQuitButtonPressed():
	GameManager.QuitGame()
	

func onContinueButtonPressed() -> void:
	pass # Replace with function body.
