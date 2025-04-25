class_name DaggerBanditHurtbox extends Hurtbox


func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		emit_signal("damageTaken", area.getDamage())
