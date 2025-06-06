class_name IsTakingDamage extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var just_damaged = blackboard.get_value("justTookDamage", false)
	var damage_time = blackboard.get_value("damageTime", 0)
	
	if actor is CharacterBody2D and just_damaged:
		actor.modulate = Color.RED
	else:
		actor.modulate = Color.WHITE
	
	# Clear flag after reaction duration (500ms in this case)
	if Time.get_ticks_msec() - damage_time > 500:
		blackboard.set_value("justTookDamage", false)
		return FAILURE

	AudioManager.stop_tagged_sound("enemyHit2")
	return SUCCESS if just_damaged else FAILURE
