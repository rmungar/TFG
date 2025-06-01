class_name DaggerBandit extends Enemy

@onready var behaviourTree: BeehaveTree = $DaggerBanditBeehaveTree

@export_category("Health")
@export var health = 200
@export var isAlive = true

signal Dead()

var directionTowardsPlayer = 0

func _on_hurt_box_damage_taken(damageTaken: int) -> void:
	if not $DamageTimer.is_stopped():
		return
	behaviourTree.blackboard.set_value("justTookDamage", true)
	behaviourTree.blackboard.set_value("damageTime", Time.get_ticks_msec())
	
	health -= damageTaken
	$DamageTimer.start()
	if health <= 0:
		isDead()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func isDead():
	if !isAlive:
		return
	isAlive = false
	if directionTowardsPlayer == 1:
		animationPlayer.play("Death_Right")
	else:
		animationPlayer.play("Death_Left")
	await animationPlayer.animation_finished
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.money += reward
	player.updateMoney.emit(player.money)
	Dead.emit()
	queue_free()
