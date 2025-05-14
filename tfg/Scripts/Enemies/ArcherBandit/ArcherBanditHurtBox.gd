class_name ArcherBanditHurtbox extends Hurtbox

signal damageTaken(damage: int)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		emit_signal("damageTaken", area.getDamage())
