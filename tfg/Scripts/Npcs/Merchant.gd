class_name Merchant extends Node


@export var merchantName: String
@export var items: Inventory
var playerReference: Player = null




func _ready() -> void:
	$Indicator.visible = false


func _on_interaction_body_entered(body: Node2D):
	if body is Player:
		$Indicator.visible = true
		playerReference = body


func _on_interaction_body_exited(body:Node2D):
	if body is Player:
		$Indicator.visible = false
		playerReference = null
