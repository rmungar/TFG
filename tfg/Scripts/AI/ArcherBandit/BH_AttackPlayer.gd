class_name ArcherBanditAttackPlayer extends ActionLeaf

@export var attackRange: float = 200.0
@export var damageDealt: int = 10

var attack_completed: bool = false
var _animation_locked: bool = false

func tick(actor: Node, blackboard: Blackboard) -> int:
	# Get required values from blackboard
	var player: Node2D = blackboard.get_value("player")
	var direction: float = blackboard.get_value("directionToPlayer")
	
	# Validate conditions
	if not player:
		return FAILURE
		
	# If attack is already in progress
	if blackboard.get_value("isAttacking", false):
		return RUNNING if !attack_completed else SUCCESS
		
	# Check distance
	var distance = actor.global_position.distance_to(player.global_position)
	if distance > attackRange:
		return FAILURE
	
	# Start attack - lock animations first
	_animation_locked = true
	blackboard.set_value("isAttacking", true)
	blackboard.set_value("animationLocked", true)  # For other behaviors to check
	
	var animName = "Attack_Left" if direction < 0 else "Attack_Right"
	var anim_player: AnimationPlayer = actor.get_node("AnimationPlayer")
	
	# Disconnect first to avoid duplicate connections
	if anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.disconnect(_on_animation_finished)
	
	anim_player.animation_finished.connect(_on_animation_finished.bind(actor, blackboard))
	anim_player.play(animName)
	
	attack_completed = false
	
	# Spawn arrow at appropriate animation frame 
	# (consider using AnimationPlayer call track instead)
	actor.spawnArrow(player.global_position)
	blackboard.set_value("timeSinceLastAttack", Time.get_ticks_msec())
	
	return RUNNING

func _on_animation_finished(anim_name: StringName, actor: Node, blackboard: Blackboard) -> void:
	if anim_name in ["Attack_Left", "Attack_Right"]:
		blackboard.set_value("isAttacking", false)
		blackboard.set_value("animationLocked", false)
		_animation_locked = false
		attack_completed = true
		
		# Disconnect the signal after use
		var anim_player: AnimationPlayer = actor.get_node("AnimationPlayer")
		if anim_player.animation_finished.is_connected(_on_animation_finished):
			anim_player.animation_finished.disconnect(_on_animation_finished)
