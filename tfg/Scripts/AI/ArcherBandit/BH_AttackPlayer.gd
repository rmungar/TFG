class_name ArcherBanditAttackPlayer extends ActionLeaf

@export var attackRange: float = 200.0  
@export var damageDealt: int = 10

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Node2D = blackboard.get_value("player")
	var direction = blackboard.get_value("directionToPlayer")
	var playerPosition = blackboard.get_value("playerPosition")
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
			
		actor.spawnArrow(player.global_position)
		blackboard.set_value("timeSinceLastAttack", Time.get_ticks_msec())
		return SUCCESS
