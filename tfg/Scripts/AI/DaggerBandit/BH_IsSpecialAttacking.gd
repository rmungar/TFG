class_name DaggerBanditIsSpecialAttacking extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	var player: Player = blackboard.get_value("player")
	
	if not player:
		return FAILURE
	else:
		var animationPlayer: AnimationPlayer = actor.get_node("AnimationPlayer")
		if animationPlayer.current_animation == "SpecialAttack_Left" or animationPlayer.current_animation == "SpecialAttack_Right":
			return SUCCESS
		else:
			return FAILURE
