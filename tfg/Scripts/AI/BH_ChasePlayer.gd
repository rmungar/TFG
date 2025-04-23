class_name ChasePlayer extends ActionLeaf

@export var speed: float = 100.0
@export var range: float = 30.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	
	var playerPosition = blackboard.get_value("player_position")
	if not playerPosition:
		return FAILURE
		
	var direction = (playerPosition - actor.global_position)
	var normalizedDirection = (direction).normalized()
	blackboard.set_value("directionToPlayer",direction.x)
	if direction.x < 0:
		actor.get_node("AnimationPlayer").play("Run_Left")
	else:
		actor.get_node("AnimationPlayer").play("Run_Right")
	actor.global_position.x += normalizedDirection.x * speed * get_physics_process_delta_time()
	
	blackboard.set_value("attack_range", range)
	
	var horizontalDistance = abs(actor.global_position.x - playerPosition.x)
	if horizontalDistance <= range:
		return SUCCESS
	
	return RUNNING
