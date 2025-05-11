class_name DaggerBanditSpecialAttack extends ActionLeaf

@export var specialAttackRange: float = 50.0  
@export var specialAttackDamage: int = 10

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Node2D = blackboard.get_value("player")
	var directionToPlayer = blackboard.get_value("directionToPlayer")
	if not player:
		return FAILURE
	
	# Check distance
	var distance = actor.global_position.distance_to(player.global_position)
	if distance > specialAttackRange:
		return FAILURE  
	else:

		if directionToPlayer < 0:
			actor.get_node("AnimationPlayer").play("SpecialAttack_Left")
		else:
			actor.get_node("AnimationPlayer").play("SpecialAttack_Right")
			
		var specialAttackHitbox = actor.get_node("SpecialAttackHitbox")
		var specialAttackHitboxCollisionShape: CollisionPolygon2D = specialAttackHitbox.get_child(0)
		specialAttackHitboxCollisionShape.disabled = false
		
		blackboard.set_value("timeSinceLastSpecialAttack", Time.get_ticks_msec())
		
		return SUCCESS
