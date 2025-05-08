class_name Chest extends StaticBody2D

@export var itemDropScene: PackedScene
@export var dropForce: float = 150.0
@export var health: int = 3  
@export var dropItem: PackedScene = load("res://Scenes/Interactables/Item.tscn")
@export var hitFlashColor: Color = Color.RED
@export var openColor: Color = Color.DIM_GRAY

var isOpened: bool = false
var currentHealth: int

func _ready():
	currentHealth = health

func _on_hitbox_area_entered(area: Area2D):
	print("!!")
	if isOpened: 
		return
	if area is Hitbox:
		take_damage(1)

func take_damage(amount: int):
	currentHealth -= amount
	
	modulate = hitFlashColor
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if currentHealth <= 0:
		open_chest()

func open_chest():
	isOpened = true
	
	modulate = Color.BLACK
	$ModulateTimer.start()
	await $ModulateTimer.timeout
	modulate = openColor
	
	var item = dropItem.instantiate()
	get_parent().add_child(item)
	item.global_position = global_position
	
	var dropDirection = Vector2(
		randf_range(-1, 1),
		randf_range(-0.5, -1.5)
	).normalized()
	
	if item.has_method("apply_impulse"):
		item.apply_impulse(dropDirection * dropForce)
	
	elif item.has_method("set_velocity"):
		item.velocity = dropDirection * dropForce
	$CollisionShape2D.set_deferred("disabled", true)
