class_name IsInSpecialAttackRange extends ConditionLeaf

@export var SPECIAL_ATTACK_RANGE: float = 50.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player = blackboard.get_value("player")
	if player and actor.global_position.distance_to(player.global_position) <= SPECIAL_ATTACK_RANGE:
		return SUCCESS
	return FAILURE
