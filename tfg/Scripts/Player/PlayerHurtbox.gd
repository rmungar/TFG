class_name PlayerHurtbox extends Hurtbox

signal damageTaken(damage: int, knockback: Vector2)

@export var knockbackForce: float = 300.0
@export var upwardForce: float = 100.0  

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("getDamage"):
		var direction = sign(area.global_position.x - global_position.x)
		if area is Hitbox:
			emit_signal("damageTaken", area.getDamage(), Vector2(-direction * knockbackForce, -upwardForce))
		if area is Spike:
			emit_signal("damageTaken", area.getDamage(), Vector2(-direction * knockbackForce, -upwardForce))
