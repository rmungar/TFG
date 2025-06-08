extends CharacterBody2D
# Referencias a nodos
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var attack_timer = $AttackTimer
# Estados básicos
enum WidowState { IDLE, CHASING, ATTACKING }
# Variables principales
var isAlive: bool = true
@export var speed: float = 100.0
@export var health: int = 200
@export var maxHealth: int = 200
@export var damage: int = 25
@export var detection_range: float = 300.0
@export var attack_range: float = 60.0
var current_state: WidowState = WidowState.IDLE
var player: Player = null
var gravity = 980.0
var can_attack: bool = true
var reward: int = 400
signal Defeated()


func _ready():
	$AttackHitboxLeft.monitoring = false
	$AttackHitboxRight.monitoring = false
	$SpitHitboxLeft.monitoring = false
	$SpitHitboxRight.monitoring = false
	health = maxHealth
	player = get_tree().get_first_node_in_group("Player")
	attack_timer.timeout.connect(_on_attack_finished)

func _physics_process(delta):
	if isAlive:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# Lógica de estados
		match current_state:
			WidowState.IDLE:
				handle_idle()
			WidowState.CHASING:
				handle_chasing()
			WidowState.ATTACKING:
				handle_attacking()
		
		move_and_slide()

func handle_idle():
	velocity.x = 0
	animation_player.play("Idle")
	if player and distance_to_player() <= detection_range:
		current_state = WidowState.CHASING

func handle_chasing():
	if not player or distance_to_player() > detection_range:
		current_state = WidowState.IDLE
		return
	
	# Atacar si está cerca
	if distance_to_player() <= attack_range and can_attack:
		current_state = WidowState.ATTACKING
		return
	
	# Perseguir jugador
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * speed
	
	# Voltear sprite
	if direction.x > 0:
		sprite.scale.x = abs(sprite.scale.x)
	elif direction.x < 0:
		sprite.scale.x = -abs(sprite.scale.x)
	
	if animation_player:
		animation_player.play("Walk")
		AudioManager.play_tagged_sound("widowWalk", "res://Assets/Sounds/widowWalk.mp3", -40.0)

func handle_attacking():
	velocity.x = 0

	if can_attack:
		AudioManager.stop_tagged_sound("widowWalk")
		can_attack = false
		attack_timer.start(1.0)
		var player_is_to_right = player.global_position.x > global_position.x
		var dist = distance_to_player()
		if health < 50 and dist > attack_range:
			if animation_player:
				animation_player.play("Spit")
			if player_is_to_right:
				$SpitHitboxRight.monitoring = true
				if $SpitHitboxRight.has_overlapping_bodies():
					for body in $SpitHitboxRight.get_overlapping_bodies():
						if body == player:
							damage_player()
							break
			else:
				$SpitHitboxLeft.monitoring = true
				if $SpitHitboxLeft.has_overlapping_bodies():
					for body in $SpitHitboxLeft.get_overlapping_bodies():
						if body == player:
							damage_player()
							break
			await animation_player.animation_finished
			$SpitHitboxLeft.monitoring = false
			$SpitHitboxRight.monitoring = false
		else:
			if animation_player:
				animation_player.play("Attack")
			if player_is_to_right:
				$AttackHitboxRight.monitoring = true
				if $AttackHitboxRight.has_overlapping_bodies():
					for body in $AttackHitboxRight.get_overlapping_bodies():
						if body == player:
							damage_player()
							break
			else:
				$AttackHitboxLeft.monitoring = true
				if $AttackHitboxLeft.has_overlapping_bodies():
					for body in $AttackHitboxLeft.get_overlapping_bodies():
						if body == player:
							damage_player()
							break
			await animation_player.animation_finished
			$AttackHitboxLeft.monitoring = false
			$AttackHitboxRight.monitoring = false
		current_state = WidowState.CHASING


func distance_to_player() -> float:
	if not player:
		return 999.0
	return global_position.distance_to(player.global_position)

func damage_player():
	if player and player.has_method("_on_hurtbox_damage_taken"):
		player._on_hurtbox_damage_taken(30, Vector2(10,-20) if player.global_position.x > global_position.x else Vector2(-10,-20))

func take_damage(amount: int):
	AudioManager.play_sound("res://Assets/Sounds/widowHit.wav", -35.0)
	health -= amount
	modulate = Color.SKY_BLUE
	await  get_tree().create_timer(0.3).timeout
	modulate = Color.WHITE
	if health <= 0:
		die()

func die():
	if animation_player:
		isAlive = false
		$Hurtbox.monitoring = false
		animation_player.play("Death")
		AudioManager.play_sound("res://Assets/Sounds/widowDeath.wav", -35.0)
		await animation_player.animation_finished
		GameManager.bossDefeated = true
		var player: Player = get_tree().get_first_node_in_group("Player")
		player.money += reward
		player.updateMoney.emit(player.money)
		Defeated.emit()
	queue_free()

func _on_attack_finished():
	can_attack = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is NormalAttackHitBox or area is HeavyAttackHitbox:
		take_damage(area.getDamage())
