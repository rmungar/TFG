class_name DaggerBandit extends CharacterBody2D

@export_category("Health")
@export var health = 200
@export var isAlive = true

var directionTowardsPlayer = 0

@onready var animationPlayer = $AnimationPlayer


func _on_hurt_box_hurt(damageTaken: int) -> void:
	health -= damageTaken
	if health <= 0:
		isAlive = false


func isDead():
	if directionTowardsPlayer == 0:
		animationPlayer.play("Death_Right")
	else:
		animationPlayer.play("Death_Left")
	await animationPlayer.animation_finished
	queue_free()
