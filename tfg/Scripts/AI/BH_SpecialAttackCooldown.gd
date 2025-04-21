class_name SpecialAttackCooldown extends CooldownDecorator

@export var SPECIAL_ATTACK_COOLDOWN: float = 6.0
var TIME_SINCE_LAST_SPECIAL_ATTACK: float = -9999.9

func tick(agent: Node, blackboard: Blackboard) -> int:
	if Time.get_ticks_msec() - TIME_SINCE_LAST_SPECIAL_ATTACK < SPECIAL_ATTACK_COOLDOWN * 1000:
		return FAILURE
	TIME_SINCE_LAST_SPECIAL_ATTACK = Time.get_ticks_msec()
	return super.tick(agent, blackboard)
