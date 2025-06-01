extends CharacterBody2D

enum WidowState { IDLE, PATROLLING, CHASING, ATTACKING }

@export var speed := 50.0
@export var chaseSpeed := 100.0
@export var gravity := 980.0
@export var attackRange := 48.0
@export var detectionRange := 180.0
@export var jumpForce := -350.0
@export var fallOffset := 32.0

var state: WidowState = WidowState.IDLE
var player: Node2D = null
var hasLanded := false

@onready var sprite := $Sprite2D
@onready var anim := $AnimationPlayer

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	velocity.y += gravity * delta

	if not is_on_floor():
		hasLanded = false
		if velocity.y < 0:
			if anim.current_animation != "Jump":
				anim.play("Jump")
		else:
			if anim.current_animation != "Fall":
				anim.play("Fall")
	else:
		if not hasLanded and state == WidowState.CHASING:
			_check_impact()
			hasLanded = true

	match state:
		WidowState.IDLE:
			anim.play("Idle")
			_check_for_player()

		WidowState.PATROLLING:
			anim.play("Walk")
			_patrol()
			_check_for_player()

		WidowState.CHASING:
			if is_on_floor():
				anim.play("Walk")
			_chase_player()

		WidowState.ATTACKING:
			velocity.x = 0

	if player and abs(position.x - player.position.x) < 10 and abs(position.y - player.position.y) < 30:
		velocity.x += 40 * sign(position.x - player.position.x)

	_check_spit_attack()
	_check_buff()

	move_and_slide()

func _check_for_player():
	if not player:
		return

	var horizontalDist = abs(position.x - player.position.x)
	var verticalDist = abs(position.y - player.position.y)

	if horizontalDist <= detectionRange and verticalDist <= 80:
		var space = get_world_2d().direct_space_state
		var ray = PhysicsRayQueryParameters2D.create(position, player.position)
		ray.exclude = [self]
		ray.collision_mask = collision_mask
		var result = space.intersect_ray(ray)
		if result and result.collider == player:
			state = WidowState.CHASING

func _patrol():
	velocity.x = speed if sprite.flip_h else -speed
	if is_on_wall():
		sprite.flip_h = !sprite.flip_h

func _chase_player():
	if not player:
		state = WidowState.IDLE
		return

	var dir = sign(player.position.x - position.x)

	if dir != 0:
		sprite.flip_h = dir < 0

	velocity.x = dir * chaseSpeed

	if is_on_wall() and is_on_floor():
		velocity.y = jumpForce
		velocity.x = dir * (chaseSpeed * 0.5)

	if not is_on_floor() and abs(position.x - player.position.x) < 16:
		velocity.x += 40 * sign(position.x - player.position.x)

	if position.distance_to(player.position) <= attackRange:
		state = WidowState.ATTACKING
		_do_attack()

func _do_attack():
	anim.play("Attack")
	await anim.animation_finished
	if player and position.distance_to(player.position) <= attackRange:
		if player.has_method("take_damage"):
			player.take_damage(10)
	state = WidowState.CHASING

func _do_spit():
	anim.play("Spit")
	await anim.animation_finished
	if player and position.distance_to(player.position) <= 40:
		if player.has_method("take_damage"):
			player.take_damage(8)
	state = WidowState.CHASING

func _do_buff():
	anim.play("Buff")
	await anim.animation_finished

	if player:
		if player.has_method("take_damage"):
			player.take_damage(5)
		
		# Intentamos empujar al jugador
		if player.has_method("apply_central_impulse"):
			var repelForce = Vector2(sign(player.position.x - position.x) * 150, -200)
			player.apply_central_impulse(repelForce)

	state = WidowState.CHASING

func _check_impact():
	if not player:
		return
	if position.distance_to(player.position) <= 48:
		if player.has_method("take_damage"):
			player.take_damage(5)

func _check_spit_attack():
	if not player or state == WidowState.ATTACKING:
		return
	
	var distance = position.distance_to(player.position)
	var verticalDifference = abs(player.position.y - position.y)

	if player.is_on_floor() and distance > 120 and distance < 160 and verticalDifference < 48:
		state = WidowState.ATTACKING
		_do_spit()

func _check_buff():
	if not player or state == WidowState.ATTACKING:
		return

	var horizontalDistance = abs(player.position.x - position.x)
	var verticalDistance = player.position.y - position.y

	if verticalDistance < -40 and horizontalDistance < 32:
		state = WidowState.ATTACKING
		_do_buff()
