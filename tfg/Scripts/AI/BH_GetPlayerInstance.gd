class_name GetPlayerInstance extends ActionLeaf

func tick (actor: Node, blackboard: Blackboard) -> int:
	var GAME_NODE = get_parent().get_parent().get_parent().get_parent()
	var PLAYER = GAME_NODE.find_child("Player")
	if PLAYER:
		blackboard.set_value("player", PLAYER)
		return SUCCESS
	else:
		return FAILURE
