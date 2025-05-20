class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var stateMachine: StateMachine = $StateMachine
@onready var normalAttackHitbox: Area2D = $NormalAttackHitbox
@onready var heavyAttackHitbox: HeavyAttackHitbox = $HeavyAttackHitbox
@onready var actionableFinder: Area2D = $ActionableFinder


@export_category("Movement")
@export var speed: float = 200.0
@export var airSpeed: float = -150.0
@export var airAcceleration: float = 0.1
@export var jumpStrength: float = -350.0
@export var gravity: float = 980.0
@export var deceleration: float = 0.2
var facingDirection: float 



@export_category("Health")
@export var HP: int = 100
@export var isAlive: bool = true
var isInteracting: bool = false


@export_category("Inventory")
@export var inventory: Inventory


func _ready() -> void:
	stateMachine.configure(self)

func _process(delta: float) -> void:
	
	if isAlive:
		if Input.is_action_pressed("MoveLeft"):
			facingDirection = -1.0
			sprite.flip_h = true
			normalAttackHitbox.position.x = -36
			heavyAttackHitbox.position.x = -4
		elif Input.is_action_pressed("MoveRight"):
			facingDirection = 1.0
			sprite.flip_h = false
			normalAttackHitbox.position.x = 0
			heavyAttackHitbox.position.x = 4

func _physics_process(delta: float) -> void:
	if isAlive:
		if not is_on_floor():
			velocity.y += gravity * delta
		if not Input.is_action_pressed("MoveLeft") and not Input.is_action_pressed("MoveRight"):
			facingDirection = 0
		move_and_slide()


func _on_hurtbox_damage_taken(damage: int, knockback: Vector2) -> void:
	if not $DamageCooldown.is_stopped():
		return 
	if knockback == null:
		pass
	velocity = knockback
	self.modulate = Color.RED
	$ModulateTimer.start()
	await $ModulateTimer.timeout
	self.modulate = Color.WHITE
	HP -= damage
	$DamageCooldown.start()
	if HP <= 0:
		isAlive = false
		$AnimationPlayer.play("Death")
		await $AnimationPlayer.animation_finished
		queue_free()



func collectItem(item: Item):
	var newItem = InventoryItem.new()
	newItem.name = item.itemName
	newItem.texture = item.itemTexture
	inventory.insert(newItem)
