class_name Chest extends StaticBody2D

@export var drop: PackedScene = preload("res://Scenes/Interactables/Item.tscn")
@export var dropForce: float = 150.0
@export var interactionRadius: float = 50.0

var isOpened: bool = false
var playerInRange: bool = false

func _ready():
	# Debug: Verify drop scene is loaded
	if not drop:
		push_error("Drop scene failed to load!")
	else:
		print("Drop scene loaded successfully: ", drop.resource_path)

func _process(_delta):
	if Input.is_action_just_pressed("Interact") and playerInRange and not isOpened:
		openChest()

func openChest():
	isOpened = true
	
	# Visual effect
	modulate = Color.GOLD
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE
	
	spawnItems()
	$CollisionShape2D.set_deferred("disabled", true)

func spawnItems():
	print("Attempting to spawn item...")
	
	# 1. Verify drop scene
	if not drop:
		push_error("No drop scene assigned!")
		return
	
	# 2. Create item instance
	var item = drop.instantiate()
	print("Item instantiated: ", item)
	item.itemName = "HealthModule"
	item.itemTexture = load("res://Assets/Tilesets/Simple Items/HealingModuleSprite.png")
	
	# 3. Add to scene tree
	var parent = get_parent()
	if not parent:
		push_error("Chest has no parent node!")
		return
	
	parent.add_child(item)
	print("Item added to tree. Parent: ", item.get_parent())
	
	# 4. Position item
	item.global_position = global_position + Vector2(0, -16)
	print("Item position set to: ", item.global_position)
	
	# 5. Apply force (if RigidBody2D)
	if item is RigidBody2D:
		var direction = Vector2(
			randf_range(-1, 1),
			randf_range(-1.5, -0.5)
		).normalized()
		item.apply_central_impulse(direction * dropForce)
		print("Impulse applied: ", direction * dropForce)
	else:
		push_warning("Item is not a RigidBody2D - can't apply impulse")

func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		playerInRange = true

func _on_interaction_area_body_exited(body):
	if body.is_in_group("Player"):
		playerInRange = false
