class_name IsNearPlayer extends ConditionLeaf

@export var detectionRange: float = 200.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Player = blackboard.get_value("player")
	if not player:
		return FAILURE
		
	var distanceToPlayer = (player.global_position - actor.global_position).length()
	
	
	if distanceToPlayer > detectionRange:
		actor.get_node("AnimationPlayer").play("Idle_Right")
		return FAILURE
	
	if distanceToPlayer < 0 and distanceToPlayer > -1:
		actor.get_node("AnimationPlayer").play("Idle_Left")
		return FAILURE
	
	if distanceToPlayer > 0 and distanceToPlayer < 1:
		actor.get_node("AnimationPlayer").play("Idle_Right")
		return FAILURE
	
	blackboard.set_value("player_position", player.global_position)
	blackboard.set_value("player_detected", true)
	
	return SUCCESS
