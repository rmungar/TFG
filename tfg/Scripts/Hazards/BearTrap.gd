class_name BearTrap extends Area2D

@export var damage = 10



func _ready() -> void:
	start()



func getDamage()-> int:
	return damage


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimatedSprite2D.play("Trigger")
		$CollisionShape2D.call_deferred("set_disabled", false)
		AudioManager.play_sound("res://Assets/Sounds/bearTrapClench.mp3", -40.0)
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("Closed")
		await get_tree().create_timer(2).timeout
		AudioManager.play_sound("res://Assets/Sounds/bearTrapSet.mp3", -40.0)
		await get_tree().create_timer(2).timeout
		start()


func start():
	$AnimatedSprite2D.play("Idle")
	$CollisionShape2D.disabled = true
