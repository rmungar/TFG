class_name Actionable extends Area2D

signal playerInRange(body:Node2D)
signal playerOutOfRange


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		playerInRange.emit(body)




func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		playerOutOfRange.emit()
