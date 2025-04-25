class_name IsAlive extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	if actor.isAlive:
		
		blackboard.set_value("delta", actor.get_process_delta_time())
		
		return SUCCESS
	else:
		return FAILURE
