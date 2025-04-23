class_name IsInSpecialAttackRange extends ConditionLeaf

@export var specialAttackRange: float = 50.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player = blackboard.get_value("player")
	if player and actor.global_position.distance_to(player.global_position) <= specialAttackRange:
		return SUCCESS
	return FAILURE
