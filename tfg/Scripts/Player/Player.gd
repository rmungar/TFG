class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var stateMachine: StateMachine = $StateMachine
@onready var normalAttackHitbox: Area2D = $NormalAttackHitbox
@onready var heavyAttackHitbox: HeavyAttackHitbox = $HeavyAttackHitbox
@onready var actionableFinder: Area2D = $ActionableFinder
@onready var healChargeTimer: Timer = $HealChargeTimer

################################################################################

@export_category("Movement")
@export var speed: float = 200.0
@export var airSpeed: float = -150.0
@export var airAcceleration: float = 0.1
@export var jumpStrength: float = -350.0
@export var gravity: float = 980.0
@export var deceleration: float = 0.2
var facingDirection: float 
var canMove: bool = true
signal Awake()

var lastSafePosition: Vector2

################################################################################

@export_category("Health")
@export var MaxHP: int = 100
@export var HP: int = 100
@export var isAlive: bool = true
signal updateHealth(currentHp: int, maxHp: int)

################################################################################

var isInteracting: bool = false
var canHeal: bool = false
signal updateHeals(current: int, max: int)

var maxHeals: int = 3
var currentHeals: int = 3
var healingCD: float = 5.0
var isRechargingHeals: bool = false

################################################################################

@export_category("Inventory")
@export var inventory: Inventory
@export var money: int = 0
signal updateMoney(money: int)

################################################################################

var shouldWakeUp: bool = true
var canAttack: bool = false

func _ready() -> void:
	updateHealth.emit(HP, MaxHP)
	updateMoney.emit(money)
	updateHeals.emit(currentHeals, maxHeals)
	stateMachine.configure(self)
	healChargeTimer.timeout.connect(_on_heal_charge_timer_timeout)

func _process(delta: float) -> void:
	canAttack = inventory.search("AttackModule")
	canHeal = inventory.search("HealthModule")
	
	if isAlive and canMove and !GameManager.isDialogInScreen:
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
			
			
	if Input.is_action_just_pressed("Heal") and canHeal and currentHeals > 0:
		onHeal()
		currentHeals -= 1
		updateHeals.emit(currentHeals, maxHeals)
		if not isRechargingHeals:
			isRechargingHeals = true
			healChargeTimer.start(healingCD)

func _physics_process(delta: float) -> void:
	if isAlive:
		if is_on_floor():
			lastSafePosition = global_position
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
	updateHealth.emit(HP, MaxHP)
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

func onHeal():
	if HP + 20 > MaxHP:
		HP = MaxHP
	else:
		HP += 20
	updateHealth.emit(HP, MaxHP)

func _on_heal_charge_timer_timeout():
	if currentHeals < maxHeals:
		currentHeals += 1
		updateHeals.emit(currentHeals, maxHeals)
		healChargeTimer.start(healingCD)
	else:
		isRechargingHeals = false

func teleport(newPosition: Vector2):
	global_position = newPosition


func WokenUp() -> void:
	Awake.emit()
