class_name SaveSlot extends Control


@export var saveFileNumber: int
signal wantsToDelete(saveFileNumber: int)
signal wantsToPlay(saveFileNumber: int)

func _ready() -> void:
	pass


func _on_delete_button_pressed() -> void:
	print("Chetos deletos")
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	wantsToDelete.emit(saveFileNumber)


func _on_play_button_pressed() -> void:
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	wantsToPlay.emit(saveFileNumber)


func getFocusableButton():
	return $NinePatchRect/PlayButton
