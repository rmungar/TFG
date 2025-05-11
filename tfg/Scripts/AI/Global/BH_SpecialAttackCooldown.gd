class_name SpecialAttackCooldown extends CooldownDecorator

@export var specialAttackCooldown: float = 6.0
var timeSinceLastSpecialAttack: float = -9999.9

func tick(agent: Node, blackboard: Blackboard) -> int:
	if Time.get_ticks_msec() - timeSinceLastSpecialAttack < specialAttackCooldown * 1000:
		return FAILURE
	timeSinceLastSpecialAttack = Time.get_ticks_msec()
	return super.tick(agent, blackboard)
