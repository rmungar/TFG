class_name IsNearPlayer extends ConditionLeaf

@export var DETECTION_RANGE: float = 200.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var GAME_NODE = get_parent().get_parent().get_parent().get_parent().get_parent()
	var PLAYER = GAME_NODE.find_child("Player")
	blackboard.set_value("player", PLAYER)
	if not PLAYER:
		return FAILURE
		
	var to_PLAYER = PLAYER.global_position - actor.global_position
	var DISTANCE = to_PLAYER.length()
	
	if DISTANCE > DETECTION_RANGE:
		$"../../../../AnimationPlayer".play("Idle_Right")
		return FAILURE
	
	blackboard.set_value("player_position", PLAYER.global_position)
	blackboard.set_value("player_detected", true)
	
	return SUCCESS
