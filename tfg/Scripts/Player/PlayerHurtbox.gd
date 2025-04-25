class_name PlayerHurtbox extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		emit_signal("damageTaken", area.getDamage())
