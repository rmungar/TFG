class_name AttackCooldown extends CooldownDecorator

@export var cooldown: float = 2.0
var timeSinceLastAttack: float = 0.0

func tick(agent: Node, blackboard: Blackboard) -> int:
	if Time.get_ticks_msec() - timeSinceLastAttack < cooldown * 1000:
		return FAILURE
	timeSinceLastAttack = Time.get_ticks_msec()
	return super.tick(agent, blackboard)
