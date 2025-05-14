class_name ArcherBandit extends CharacterBody2D

var is_attacking := false  # Tracks if currently attacking
@onready var blackboard: Blackboard  = $ArcherBanditBeehaveTree.blackboard # Assuming you have a Blackboard reference
var arrowScene: PackedScene = preload("res://Scenes/Enemies/ArcherBandit/arrow.tscn")

var isAlive = true
@export var health = 100

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
	print("Hurtbox Layer: ", $Hurtbox.collision_layer)
	print("Hurtbox Mask: ", $Hurtbox.collision_mask)
	$Hurtbox.monitoring = true


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
	
	health -= damageTaken
	$DamageTimer.start()
	if health <= 0:
		isAlive = false
		isDead()

func isDead():
	if directionTowardsPlayer == 1:
		$AnimationPlayer.play("Death_Right")
	else:
		$AnimationPlayer.play("Death_Left")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _input(event):
	if event.is_action_pressed("debug"):  # Assign a key in Input Map
		_on_hurtbox_damage_taken(10)  # Force damage
