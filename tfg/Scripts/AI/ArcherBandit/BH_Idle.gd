class_name ArcherBanditIdle extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
	# Skip if ANY animation is locked (attack or otherwise)
	if blackboard.get_value("animationLocked", false):
		return FAILURE
	
	var direction = blackboard.get_value("directionToPlayer", 1)
	var anim_player = actor.get_node("AnimationPlayer")
	
	# Extra safety: Don't interrupt if something is already playing
	if anim_player.is_playing():
		return FAILURE
	
	if direction < 0:
		anim_player.play("Idle_Left")
	else:
		anim_player.play("Idle_Right")
	return SUCCESS
