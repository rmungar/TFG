extends Node

@onready var screenManager: ScreenManager = ScreenManager
@onready var DoorsScene = load("res://Scenes/Interactables/Doors.tscn")
@onready var doors = DoorsScene.instantiate()

# ADD DOORS 1 TO 3 HERE



func toSaveFilesScreen():
	get_tree().change_scene_to_file(screenManager.saveFilesScreen)

func toCreditsScreen():
	pass

func toOptionsScreen():
	pass

func QuitGame():
	get_tree().quit()
