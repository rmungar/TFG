class_name Arrow extends RigidBody2D

@export var arrowDamage: int = 50
@export var launchForce: float = 800.0

var hasImpacted: bool = false

func _ready():
	# Set up collision detection
	contact_monitor = true
	max_contacts_reported = 1
	
	# Launch arrow
	gravity_scale = 3.0
	apply_central_impulse(Vector2.DOWN * launchForce)
	
	# Auto-delete after 5 seconds if nothing hit
	await get_tree().create_timer(5.0).timeout
	if !hasImpacted:
		queue_free()

func _on_body_entered(body: Node):
	if hasImpacted or body.is_in_group("WorldBoundary"):
		return
	
	_handle_impact(body)
	

func _handle_impact(body: Node):
	$AnimatedSprite2D.play("default")
	hasImpacted = true
	if body is Player:
		body._on_hurtbox_damage_taken(arrowDamage, Vector2.ZERO)
		
	
	await $AnimatedSprite2D.animation_finished
	queue_free()
