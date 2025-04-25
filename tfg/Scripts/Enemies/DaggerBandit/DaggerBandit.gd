class_name DaggerBandit extends Enemy

@export_category("Health")
@export var health = 200
@export var isAlive = true

var directionTowardsPlayer = 0

func _on_hurt_box_damage_taken(damageTaken: int) -> void:
	health -= damageTaken
	print(health)
	if health <= 0:
		isAlive = false
		isDead()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func isDead():
	if directionTowardsPlayer == 1:
		animationPlayer.play("Death_Right")
	else:
		animationPlayer.play("Death_Left")
	await animationPlayer.animation_finished
	await get_tree().create_timer(0.1).timeout
	queue_free()
