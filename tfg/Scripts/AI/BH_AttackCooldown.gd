class_name AttackCooldown extends CooldownDecorator

@export var COOLDOWN: float = 2.0
var TIME_SINCE_LAST_ATTACK: float = 0.0

func tick(agent: Node, blackboard: Blackboard) -> int:
	if Time.get_ticks_msec() - TIME_SINCE_LAST_ATTACK < COOLDOWN * 1000:
		return FAILURE
	TIME_SINCE_LAST_ATTACK = Time.get_ticks_msec()
	return super.tick(agent, blackboard)
