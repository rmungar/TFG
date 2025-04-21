class_name IsInAttackRange extends ConditionLeaf

@export var ATTACK_RANGE: float = 35.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player = blackboard.get_value("player")
	if player and actor.global_position.distance_to(player.global_position) <= ATTACK_RANGE:
		return SUCCESS
	return FAILURE
