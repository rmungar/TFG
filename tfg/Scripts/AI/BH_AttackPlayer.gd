class_name Attack extends ActionLeaf

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
			$"../../../../AnimationPlayer".play("Attack_Left")
		else:
			$"../../../../AnimationPlayer".play("Attack_Right")
		# PLAYER.take_damage(DAMAGE)
		return SUCCESS
