class_name IsPlayerLowHP extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Player = blackboard.get_value("player")
	
	if player:
		var specialAttackHitbox = actor.get_node("SpecialAttackHitbox")
		var specialAttackHitboxCollisionShape: CollisionPolygon2D = specialAttackHitbox.get_child(0)
		specialAttackHitboxCollisionShape.disabled = true
		if player.HP <= 20:
			return SUCCESS
		else :
			return FAILURE
	else:
		return FAILURE
