class_name Arrow extends RigidBody2D

@export var arrowDamage: int = 50
@export var launchForce: float = 800.0
@export var gravityScale: float = 3.0
@export var maxLifetime: float = 5.0

var hasImpacted: bool = false

func _ready():
	
	gravityScale = 3.0
	apply_central_impulse(Vector2.DOWN * launchForce)
	

func _physics_process(delta):
	if hasImpacted:
		return

func onImpactAreaBodyEntered(body):
	if hasImpacted or body.is_in_group("ignoreArrows"):
		return
	
	hasImpacted = true
	freeze = true 
	
	$AnimatedSprite2D.play("default")
	$ImpactSound.play()
	
	if body.has_method("takeDamage"):
		body.takeDamage(arrowDamage)
	
	await $AnimatedSprite2D.animation_finished
	queue_free()

func onLifetimeTimerTimeout():
	if not hasImpacted:
		queue_free()
