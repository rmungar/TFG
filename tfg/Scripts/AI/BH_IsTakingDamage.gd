class_name IsTakingDamage extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) -> int:
	var just_damaged = blackboard.get_value("justTookDamage", true)
	var damage_time = blackboard.get_value("damageTime", 0)

	# Clear flag after reaction duration (500ms in this case)
	if Time.get_ticks_msec() - damage_time > 500:
		blackboard.set_value("justTookDamage", false)
		return FAILURE
		
	return SUCCESS if just_damaged else FAILURE
