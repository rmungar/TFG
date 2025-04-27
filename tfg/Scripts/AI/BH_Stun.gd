class_name Stun extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.velocity = Vector2.ZERO
	return RUNNING  
