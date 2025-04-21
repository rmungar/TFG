class_name IsPlayerLowHP extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var PLAYER: Player = blackboard.get_value("player")
	if PLAYER.HP < 20:
		return SUCCESS
	else :
		return FAILURE
