class_name GetPlayerInstance extends ActionLeaf

func tick (actor: Node, blackboard: Blackboard) -> int:
	var gameNode = actor.get_parent()
	var player = gameNode.find_child("Player")
	if player:
		blackboard.set_value("player", player)
		return SUCCESS
	else:
		return FAILURE
