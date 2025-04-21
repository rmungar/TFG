class_name IsNearPlayer extends ConditionLeaf

@export var DETECTION_RANGE: float = 200.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var PLAYER: Player = blackboard.get_value("player")
	if not PLAYER:
		return FAILURE
		
	var to_PLAYER = PLAYER.global_position - actor.global_position
	var DISTANCE = to_PLAYER.length()
	
	if DISTANCE > DETECTION_RANGE:
		actor.get_node("AnimationPlayer").play("Idle_Right")
		return FAILURE
	
	blackboard.set_value("player_position", PLAYER.global_position)
	blackboard.set_value("player_detected", true)
	
	return SUCCESS
