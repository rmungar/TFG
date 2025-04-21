class_name SpecialAttack extends ActionLeaf

@export var ATTACK_RANGE: float = 50.0  
@export var DAMAGE: int = 10

func tick(actor: Node, blackboard: Blackboard) -> int:
	var PLAYER: Node2D = blackboard.get_value("player")
	var DIRECITON = blackboard.get_value("directionToPlayer")
	if not PLAYER:
		return FAILURE
	
	# Check distance
	var distance = actor.global_position.distance_to(PLAYER.global_position)
	if distance > ATTACK_RANGE:
		return FAILURE  
	else:
		if DIRECITON < 0:
			actor.get_node("AnimationPlayer").play("SpecialAttack_Left")
		else:
			actor.get_node("AnimationPlayer").play("SpecialAttack_Right")
		# PLAYER.take_damage(DAMAGE)
		blackboard.set_value("timeSinceLastSpecialAttack", Time.get_ticks_msec())
		return SUCCESS
