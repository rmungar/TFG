class_name SaveSlot extends Control


@export var saveFileNumber: int
signal wantsToDelete(saveFileNumber: int)
signal wantsToPlay(saveFileNumber: int)

func _ready() -> void:
	pass


func _on_delete_button_pressed() -> void:
	print("Chetos deletos")
	wantsToDelete.emit(saveFileNumber)


func _on_play_button_pressed() -> void:
	wantsToPlay.emit(saveFileNumber)
