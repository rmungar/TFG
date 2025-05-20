class_name DetectionArea extends Area2D


signal Detected()

var count = 0

func _on_body_entered(body: Node2D) -> void:
	if body is Player and count == 0:
		print(body)
		count += 1
		Detected.emit()
