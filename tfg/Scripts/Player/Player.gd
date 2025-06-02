class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var stateMachine: StateMachine = $StateMachine
@onready var normalAttackHitbox: Area2D = $NormalAttackHitbox
@onready var heavyAttackHitbox: HeavyAttackHitbox = $HeavyAttackHitbox
@onready var actionableFinder: Area2D = $ActionableFinder
@onready var healChargeTimer: Timer = $HealChargeTimer
@onready var dashTimer: Timer = $DashTimer

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
var lastCheckPoint: Vector2

var canDash: bool = false
@export var dashSpeed: float = 600.0
@export var dashDuration: float = 0.2
var isDashing: bool = false
var dashDirection: Vector2 = Vector2.ZERO
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

var lastTilemap: String


func _ready() -> void:
	updateHealth.emit(HP, MaxHP)
	updateMoney.emit(money)
	updateHeals.emit(currentHeals, maxHeals)
	stateMachine.configure(self)
	healChargeTimer.timeout.connect(_on_heal_charge_timer_timeout)
	dashTimer.one_shot = true
	dashTimer.wait_time = dashDuration
	dashTimer.timeout.connect(_on_dash_timeout)
	inventory.update.emit()
	

func _process(delta: float) -> void:
	canAttack = inventory.search("AttackModule")
	canHeal = inventory.search("HealthModule")
	canDash = inventory.search("Dash Gem")
	
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
		
		if Input.is_action_just_pressed("Dash") and !isDashing and canMove:
			var input_vector = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
			if input_vector.length() > 0:
				dashDirection = input_vector.normalized()
				isDashing = true
				dashTimer.start()
				
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
		if isDashing:
			velocity = dashDirection * dashSpeed
		if not is_on_floor():
			velocity.y += gravity * delta
		if not Input.is_action_pressed("MoveLeft") and not Input.is_action_pressed("MoveRight"):
			facingDirection = 0
		move_and_slide()


func _on_dash_timeout():
	isDashing = false
	velocity = Vector2.ZERO


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
		respawn()

func collectItem(item: Item):
	var newItem = InventoryItem.new()
	newItem.name = item.itemName
	newItem.texture = item.itemTexture
	inventory.insert(newItem)

func onHeal():
	print("HEAL")
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

func respawn():
	HP = MaxHP
	teleport(lastCheckPoint - Vector2(0,5))
	stateMachine.configure(self)
	isAlive = true
	updateHealth.emit(HP, MaxHP)


func WokenUp() -> void:
	Awake.emit()

func apply_saved_data(data: Dictionary):
	if data.is_empty():
		return

	HP = data.get("HP", MaxHP)
	updateHealth.emit(HP, MaxHP)
	updateMoney.emit(money)
	money = data.get("money", 0)
	var checkpoint = data.get("lastCheckPoint", Vector2.ZERO)
	if typeof(checkpoint) == TYPE_STRING:
		checkpoint = parse_vector2_from_string(checkpoint)
	if !GameManager.tutorial_done:
		lastCheckPoint = checkpoint
	else:
		lastCheckPoint = Vector2(453, 240)

	lastTilemap = data.get("lastTileMap", "")

	canHeal = data.get("canHeal", false)
	canAttack = data.get("canAttack", false)
	inventory.deserialize(data.get("inventory", []))
	teleport(lastCheckPoint)



func parse_vector2_from_string(pos_string: String) -> Vector2:
	var parts = pos_string.lstrip('(').rstrip(')').split(",")
	if parts.size() == 2:
		return Vector2(parts[0].to_float(), parts[1].to_float())
	return Vector2.ZERO



func serialize() -> Dictionary:
	return {
		"HP": HP,
		"money": money,
		"canHeal": canHeal,
		"canAttack": canAttack,
		"lastCheckPoint": lastCheckPoint,
		"lastTilemap":lastTilemap,
		"inventory": inventory.serialize()
	}
