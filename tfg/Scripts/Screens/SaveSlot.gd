class_name SaveSlot extends Control





func _ready() -> void:
	$DeleteButton.visible = false
	


func _on_mouse_entered() -> void:
	$DeleteButton.visible = true


func _on_mouse_exited() -> void:
	$DeleteButton.visible = false
