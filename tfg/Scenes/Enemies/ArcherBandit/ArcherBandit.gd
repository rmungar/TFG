class_name ArcherBandit extends CharacterBody2D

var is_attacking := false  # Tracks if currently attacking
@onready var blackboard: Blackboard  = $ArcherBanditBeehaveTree.blackboard # Assuming you have a Blackboard reference
var arrowScene: PackedScene = preload("res://Scenes/Enemies/ArcherBandit/arrow.tscn")
var isAlive = true


func spawnArrow(playerPosition: Vector2):
	var arrow: Node = arrowScene.instantiate()
	
	arrow.global_position = Vector2(
		playerPosition.x, 
		-50                
	)
	get_parent().add_child(arrow)

func _ready():
	$AnimationPlayer.connect("animation_finished", _on_animation_finished)


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
