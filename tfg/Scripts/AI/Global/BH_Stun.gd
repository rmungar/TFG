class_name Stun extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.velocity = Vector2.ZERO
	var damageTimer: Timer = actor.get_node("DamageTimer")
	if not damageTimer.is_stopped():
		return SUCCESS
	
	damageTimer.start()
	return RUNNING  
