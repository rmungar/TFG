class_name IsAlive extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isAlive:
		
		blackboard.set_value("delta", actor.get_process_delta_time())
		
		var basicAttackHitbox = actor.get_node("BasicAttackHitbox")
		var basicAttackHitboxCollisionShape: CollisionShape2D = basicAttackHitbox.get_node("CollisionShape2D")
		
		var specialAttackHitbox = actor.get_node("SpecialAttackHitbox")
		var specialAttackHitboxCollisionShape: CollisionPolygon2D = specialAttackHitbox.get_child(0)
		
		basicAttackHitboxCollisionShape.disabled = true
		specialAttackHitboxCollisionShape.disabled = true
		
		return SUCCESS
	else:
		return FAILURE
