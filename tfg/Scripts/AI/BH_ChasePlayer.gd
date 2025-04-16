class_name ChasePlayer extends ActionLeaf

@export var SPEED: float = 100.0
@export var RANGE: float = 30.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var PLAYER_POSITION = blackboard.get_value("player_position")
	if not PLAYER_POSITION:
		return FAILURE
		
	var DIRECTION = (PLAYER_POSITION - actor.global_position)
	var DIRECTION_NORMALIZED = (DIRECTION).normalized()
	blackboard.set_value("directionToPlayer",DIRECTION.x)
	if DIRECTION.x < 0:
		$"../../../../AnimationPlayer".play("Run_Left")
	else:
		$"../../../../AnimationPlayer".play("Run_Right")
	actor.global_position.x += DIRECTION_NORMALIZED.x * SPEED * get_physics_process_delta_time()
	
	blackboard.set_value("attack_range", RANGE)
	
	var HORIZONTAL_DISTANCE = abs(actor.global_position.x - PLAYER_POSITION.x)
	if HORIZONTAL_DISTANCE <= RANGE:
		return SUCCESS
	
	return RUNNING
