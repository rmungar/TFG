class_name NormalAttackHitBox extends Hitbox

@export_category("Damage")
@export var damage: int = 10


func getDamage() -> int:
	return damage
