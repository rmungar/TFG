extends Portal


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		playerReference = null
