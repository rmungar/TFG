class_name Item extends RigidBody2D

# Configuration
@export var itemName: String = ""
@export var itemTexture: Texture2D
@export var pickupDelay: float = 0.5
@export var magnetStrength: float = 0.0  # 0 = no magnet effect
@export var lifetime: float = 0 # Seconds before auto-removal (0 = infinite)

var gravity = 980.0
var canPickUp: bool = false
var timeAlive: float = 0.0
var collected: bool = false
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	if pickupDelay > 0:
		await get_tree().create_timer(pickupDelay).timeout
		enable_pickup()

func _physics_process(delta):
	if not collected:
		if lifetime > 0:
			timeAlive += delta
			if timeAlive >= lifetime:
				queue_free()
		if canPickUp && magnetStrength > 0 && is_instance_valid(player):
			var direction = (player.global_position - global_position).normalized()
			var distance = global_position.distance_to(player.global_position)
			var strength = magnetStrength * (1.0 - clamp(distance / 200.0, 0.0, 0.9))
			apply_central_impulse(direction * strength * delta * 60)


func enable_pickup():
	canPickUp = true

func _on_body_entered(body: Node2D):
	if canPickUp && body.is_in_group("Player"):
		collect(body)

func collect(collector: Node):
	if collector.has_method("collectItem"):
		$DespawnTimer.start()
		$AnimatedSprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		collector.collectItem(self)
		collected = true
	await $DespawnTimer.timeout
	
	queue_free()

func apply_drop_force(direction: Vector2, force: float):
	apply_impulse(direction * force)
