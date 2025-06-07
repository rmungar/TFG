class_name ArcherBandit extends CharacterBody2D

var is_attacking := false  # Tracks if currently attacking
@onready var blackboard: Blackboard  = $ArcherBanditBeehaveTree.blackboard # Assuming you have a Blackboard reference
var arrowScene: PackedScene = preload("res://Scenes/Enemies/ArcherBandit/arrow.tscn")

var isAlive = true
@export var health = 100
@export var reward: int
@export var spawnPosition: Vector2
@export var Scene: PackedScene = preload("res://Scenes/Enemies/ArcherBandit/ArcherBandit.tscn")

signal Dead()
signal AddToRespawnList(enemyScene: PackedScene, spawnPoint: Vector2)
var directionTowardsPlayer = 0

func spawnArrow(playerPosition: Vector2):
	var arrow: Node = arrowScene.instantiate()
	
	arrow.global_position = Vector2(
		playerPosition.x + 9, 
		-50                
	)
	get_parent().add_child(arrow)

func _ready():
	$AnimationPlayer.connect("animation_finished", _on_animation_finished)
	$Hurtbox.monitoring = true


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 980 * delta
		
	move_and_slide()


func is_animation_locked(blackboard: Blackboard) -> bool:
	return blackboard.get_value("animationLocked", false)

func play_animation_safely(anim_base_name: String, blackboard: Blackboard) -> bool:
	if self.is_animation_locked(blackboard):
		return false
	
	var direction = blackboard.get_value("directionToPlayer", 1)
	var anim_name = anim_base_name + ("_Left" if direction < 0 else "_Right")
	
	var anim_player = $AnimationPlayer
	if anim_player.is_playing():  # Extra safety
		return false
	
	anim_player.play(anim_name)
	return true


func _on_animation_finished(anim_name: String):
	if anim_name.begins_with("Attack"):
		is_attacking = false  # Reset attack lock


func _on_hurtbox_damage_taken(damageTaken: int) -> void:
	if not $DamageTimer.is_stopped():
		return
	$ArcherBanditBeehaveTree.blackboard.set_value("justTookDamage", true)
	$ArcherBanditBeehaveTree.blackboard.set_value("damageTime", Time.get_ticks_msec())
	AudioManager.play_sound("res://Assets/Sounds/enemyHit2.wav", -30.0)
	health -= damageTaken
	$DamageTimer.start()
	if health <= 0:
		isAlive = false
		isDead()

func isDead():
	AudioManager.play_sound("res://Assets/Sounds/EnemyDeath.wav", -30.0)
	if directionTowardsPlayer == 1:
		$AnimationPlayer.play("Death_Right")
	else:
		$AnimationPlayer.play("Death_Left")
	$Hurtbox.set_deferred("monitoring", false)
	#$CollisionShape2D.set_deferred("disabled", true)
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.1).timeout
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.money += reward
	player.updateMoney.emit(player.money)
	AddToRespawnList.emit(Scene, spawnPosition)
	Dead.emit()
	queue_free()
