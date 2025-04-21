class_name IsAttacking extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var PLAYER: Player = blackboard.get_value("player")
	
	if not PLAYER:
		return FAILURE
	else:
		var ANIMATION_PLAYER: AnimationPlayer = actor.get_node("AnimationPlayer")
		if ANIMATION_PLAYER.current_animation == "Attack_Left" or ANIMATION_PLAYER.current_animation == "Attack_Right":
			return SUCCESS
		else:
			return FAILURE
