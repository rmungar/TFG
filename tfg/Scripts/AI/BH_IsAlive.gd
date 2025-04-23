class_name IsAlive extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isAlive:
		return SUCCESS
	else:
		return FAILURE
