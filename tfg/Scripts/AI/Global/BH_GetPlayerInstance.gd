class_name GetPlayerInstance extends ActionLeaf

func tick (actor: Node, blackboard: Blackboard) -> int:
	var gameNode = actor.get_parent()
	var player = gameNode.find_child("Player")
	if player:
		blackboard.set_value("player_position", player.global_position)
		blackboard.set_value("player_detected", true)
		var direction = player.global_position - actor.global_position
		blackboard.set_value("directionToPlayer", direction.x)
		if direction.x > 0:
			actor.directionTowardsPlayer = 1
		else:
			actor.directionTowardsPlayer = 0
		blackboard.set_value("player", player)
		return SUCCESS
	else:
		return FAILURE
