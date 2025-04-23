class_name IsAttacking extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Player = blackboard.get_value("player")
	
	if not player:
		return FAILURE
	else:
		var animationPlayer: AnimationPlayer = actor.get_node("AnimationPlayer")
		if animationPlayer.current_animation == "Attack_Left" or animationPlayer.current_animation == "Attack_Right":
			return SUCCESS
		else:
			return FAILURE
