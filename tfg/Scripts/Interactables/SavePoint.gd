class_name SavePoint extends Node2D

signal unlock()

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

func inInteractionRange(body: Node2D) -> void:
	pass


func inDetectionRange(body: Node2D) -> void:
	if body is Player:
		animatedSprite.play("StartUp")
		await animatedSprite.animation_finished
		animatedSprite.play("Idle")

func leftDetectionRange(body: Node2D) -> void:
	animatedSprite.play("Close")


func leftInteractionRange(body: Node2D) -> void:
	pass 
