class_name PlayerHurtbox extends Hurtbox

signal damageTaken(damage: int, knockback: Vector2)

@export var knockbackForce: float = 300.0
@export var upwardForce: float = 100.0  

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("getDamage"):
		var direction = sign(area.global_position.x - global_position.x)
		if area is Hitbox or area is Spike or area is SpikeEjector or area is BearTrap or area is Saw:
			emit_signal("damageTaken", area.getDamage(), Vector2(-direction * knockbackForce, -upwardForce))
