class_name Merchant extends Node


@export var merchantName: String
@export var items: Inventory
var playerReference: Player = null

@onready var shopUI: ShopUI = $Canvas/ShopUI

func _ready() -> void:
	$Indicator.visible = false

func _process(delta: float) -> void:
	if playerReference and Input.is_action_just_pressed("Interact") and !shopUI.visible:
		playerReference.canMove = false
		shopUI.open()
	elif playerReference and Input.is_action_just_pressed("Interact") and shopUI.visible:
		playerReference.canMove = true
		shopUI.close()


func _on_interaction_body_entered(body: Node2D):
	if body is Player:
		$Indicator.visible = true
		playerReference = body


func _on_interaction_body_exited(body:Node2D):
	if body is Player:
		$Indicator.visible = false
		playerReference = null
