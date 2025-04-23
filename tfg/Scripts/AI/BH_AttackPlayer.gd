class_name Attack extends ActionLeaf

@export var attackRange: float = 50.0  
@export var damageDealt: int = 10

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Node2D = blackboard.get_value("player")
	var direction = blackboard.get_value("directionToPlayer")
	if not player:
		return FAILURE
	
	# Check distance
	var distance = actor.global_position.distance_to(player.global_position)
	if distance > attackRange:
		return FAILURE  
	else:
		if direction < 0:
			actor.get_node("AnimationPlayer").play("Attack_Left")
		else:
			actor.get_node("AnimationPlayer").play("Attack_Right")
		
		blackboard.set_value("timeSinceLastAttack", Time.get_ticks_msec())
		return SUCCESS
