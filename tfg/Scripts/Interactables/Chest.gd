class_name Chest extends StaticBody2D

@export var drop: PackedScene = preload("res://Scenes/Interactables/Item.tscn")
@export var dropForce: float = 150.0
@export var interactionRadius: float = 50.0
@export var itemName: String
@export var itemTexture: String


var isOpened: bool = false
var playerInRange: bool = false


func _process(_delta):
	if Input.is_action_just_pressed("Interact") and playerInRange and not isOpened:
		openChest()

func openChest():
	isOpened = true
	
	modulate = Color.GOLD
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE
	
	spawnItems()
	$CollisionShape2D.set_deferred("disabled", true)

func spawnItems():
	
	if not drop:
		return
	
	var item = drop.instantiate()
	item.itemName = itemName
	
	if itemName != "Money":
		item.itemTexture = load(itemTexture)
	
	var parent = get_parent()
	if not parent:
		return
	
	parent.add_child(item)
	
	item.global_position = global_position + Vector2(0, -16)
	
	if item is RigidBody2D:
		var direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1.5, -0.5)
		).normalized()
		item.apply_central_impulse(direction * dropForce)
	else:
		pass

func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		playerInRange = true

func _on_interaction_area_body_exited(body):
	if body.is_in_group("Player"):
		playerInRange = false
