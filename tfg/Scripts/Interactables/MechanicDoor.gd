class_name Mechanic_Door extends Node2D

@export var isUnlocked: bool = false

signal unlocked()

func onUnlock() -> void:
	if not isUnlocked:
		AudioManager.play_sound("res://Assets/Sounds/metalDoorOpen.mp3",-30.0)
		$AnimatedSprite2D.play("Open")
		await $AnimatedSprite2D.animation_finished
		$CollisionShape2D.disabled = true
		isUnlocked = true
		emit_signal("unlocked")
		
func onLock()-> void:
	if isUnlocked:
		AudioManager.play_sound("res://Assets/Sounds/metalDoorOpen.mp3",-30.0)
		$AnimatedSprite2D.play("Close")
		await $AnimatedSprite2D.animation_finished
		$CollisionShape2D.disabled = false
		isUnlocked = false
