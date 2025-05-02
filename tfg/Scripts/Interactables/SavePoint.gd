class_name SavePoint extends Node2D

signal unlock()

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@export var requiredItem = ""
@export var alreadyInteracted: bool = false
var playerReference: Player = null
var interactable: bool = false


func _process(delta: float) -> void:
	if alreadyInteracted == true:
		modulate = Color(0.0, 0.74, 1.0, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	if playerReference and Input.is_action_just_pressed("Interact"):
		if requiredItem == "" or playerReference.has_item(requiredItem):
			alreadyInteracted = true
			emit_signal("unlock")


func inInteractionRange(body: Node2D) -> void:
	interactable = true

func inDetectionRange(body: Node2D) -> void:
	if body is Player:
		playerReference = body
		animatedSprite.play("StartUp")
		await animatedSprite.animation_finished
		animatedSprite.play("Idle")

func leftDetectionRange(body: Node2D) -> void:
	playerReference = null
	animatedSprite.play("Close")

func leftInteractionRange(body: Node2D) -> void:
	interactable = true
