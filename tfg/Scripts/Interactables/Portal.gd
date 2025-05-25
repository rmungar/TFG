class_name Portal extends StaticBody2D

signal Teleport()
var playerReference: Player = null


func _process(delta: float) -> void:
	if playerReference and Input.is_action_just_pressed("Interact"):
		Teleport.emit()
