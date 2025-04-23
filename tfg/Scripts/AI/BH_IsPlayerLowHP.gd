class_name IsPlayerLowHP extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Player = blackboard.get_value("player")
	if player.HP < 20:
		return SUCCESS
	else :
		return FAILURE
