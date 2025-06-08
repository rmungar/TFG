extends StaticBody2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_widow_defeated() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if !GameManager.bossDefeated and body is Player:
		process_mode = Node.PROCESS_MODE_INHERIT
