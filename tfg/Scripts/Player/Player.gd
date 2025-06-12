class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var stateMachine: StateMachine = $StateMachine
@onready var normalAttackHitbox: Area2D = $NormalAttackHitbox
@onready var heavyAttackHitbox: HeavyAttackHitbox = $HeavyAttackHitbox
@onready var actionableFinder: Area2D = $ActionableFinder
@onready var healChargeTimer: Timer = $HealChargeTimer
@onready var dashTimer: Timer = $DashTimer
@onready var rayCastRight: RayCast2D = $RayCastRight
@onready var rayCastLeft: RayCast2D = $RayCastLeft

################################################################################

var OnRespawnSong: String = ""


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
var jumpsLeft = 1
var lastSafePosition: Vector2
var lastCheckPoint: Vector2
var isAnyRayCastColliding: bool = false
var canDash: bool = false
var canDoubleJump: bool = false
var hasDoubleJumped: bool = false
var canWallJump: bool = false
var isWallJumping: bool = false
@export var dashSpeed: float = 600.0
@export var dashDuration: float = 0.2
var isDashing: bool = false
var dashDirection: Vector2 = Vector2.ZERO
var hasDashed: bool = false



################################################################################

@export_category("Health")
@export var MaxHP: int = 100
@export var HP: int = 100
@export var isAlive: bool = true
signal updateHealth(currentHp: int, maxHp: int)
signal updateCharges(charge: int)
var healthChargesVisible: bool = false
signal enableCharges()

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
	canDash = (inventory.isGemEquipped("Dash Gem") or inventory.isGemEquipped("WD Gem") or inventory.isGemEquipped("DD Gem"))   
	canDoubleJump = (inventory.isGemEquipped("Double Jump Gem") or inventory.isGemEquipped("DD Gem") or inventory.isGemEquipped("DW Gem"))  
	canWallJump = (inventory.isGemEquipped("Wall Jump Gem") or inventory.isGemEquipped("WD Gem") or inventory.isGemEquipped("DW Gem")) 
	
	isAnyRayCastColliding = rayCastLeft.is_colliding() or rayCastRight.is_colliding()
	
	if canHeal and !healthChargesVisible:
		enableCharges.emit()
		healthChargesVisible = true
	
	if isAlive and canMove and !GameManager.isDialogInScreen and !GameManager.pauseMenuOpen and !GameManager.isShopInScreen and !GameManager.isInventoryOpen:
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
		
		if Input.is_action_just_pressed("Dash") and canDash and !isDashing and !hasDashed and canMove:
			var input_vector = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
			if input_vector.length() > 0:
				AudioManager.play_sound("res://Assets/Sounds/dash.wav", -45.0)
				dashDirection = input_vector.normalized()
				isDashing = true
				hasDashed = true
				dashTimer.start()
				await dashTimer.timeout
		
		if Input.is_action_just_pressed("Heal") and canHeal and currentHeals > 0:
			onHeal()
			currentHeals -= 1
			updateCharges.emit(-1)
			AudioManager.play_sound("res://Assets/Sounds/heal.mp3", -35.0)
			updateHeals.emit(currentHeals, maxHeals)
			if not isRechargingHeals:
				isRechargingHeals = true
				healChargeTimer.start(healingCD)

func _physics_process(delta: float) -> void:
	if isAlive:
		
		if canMove:
			handleWallJump()
			handleDoubleJump()
		if is_on_floor():
			isWallJumping = false
			lastSafePosition = global_position
			hasDashed = false
			hasDoubleJumped = false
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
	AudioManager.play_sound("res://Assets/Sounds/playerHit.mp3", -30.0)
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
		$Hurtbox.monitoring = false
		AudioManager.play_sound("res://Assets/Sounds/playerDeath.mp3", -20.0)
		await $AnimationPlayer.animation_finished
		respawn()

func collectItem(item: Item):
	
	if item.itemName == "Credits":
		AudioManager.play_sound("res://Assets/Sounds/coins.wav",-30.0)
		money += randi() % 100 + 20
		updateMoney.emit(money)
		return
	AudioManager.play_sound("res://Assets/Sounds/itemPickup.mp3", -25.0)
	var newItem = InventoryItem.new()
	newItem.name = item.itemName
	newItem.texture = item.itemTexture
	inventory.insert(newItem)

func onHeal():
	if HP + 20 > MaxHP:
		HP = MaxHP
	else:
		HP += 20
	modulate = Color.PALE_GREEN
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE
	updateHealth.emit(HP, MaxHP)

func _on_heal_charge_timer_timeout():
	if currentHeals < maxHeals:
		currentHeals += 1
		AudioManager.play_sound("res://Assets/Sounds/healthChargeRecovered.wav", -35.0)
		updateHeals.emit(currentHeals, maxHeals)
		updateCharges.emit(1)
		healChargeTimer.start(healingCD)
	else:
		isRechargingHeals = false

func teleport(newPosition: Vector2):
	global_position = newPosition

func respawn():
	HP = MaxHP
	$Camera2D.changeRect(get_parent().get_node(lastTilemap))
	$Hurtbox.monitoring = true
	AudioManager.play_tagged_sound("AmbientSound", OnRespawnSong, -40.0)
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
	money = data.get("money", 0)
	updateMoney.emit(money)
	OnRespawnSong = data.get("lastSavedSong", "")
	AudioManager.play_tagged_sound("AmbientSound", OnRespawnSong, -40.0)
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


func handleWallJump():
	if canWallJump and !isWallJumping and Input.is_action_just_pressed("Jump") and isAnyRayCastColliding:
		isWallJumping = true
		AudioManager.play_sound("res://Assets/Sounds/jump.wav",-40.0)
		if rayCastLeft.is_colliding():
			$Sprite2D.flip_h = true
			facingDirection = -1
			velocity.x = -jumpStrength
			velocity.y = jumpStrength
		else:
			$Sprite2D.flip_h = true
			facingDirection = 1
			velocity.x = jumpStrength
			velocity.y = jumpStrength
		
		await get_tree().create_timer(0.3).timeout

func handleDoubleJump():
	if !is_on_floor() and canDoubleJump and !hasDoubleJumped and Input.is_action_just_pressed("Jump"):
		hasDoubleJumped = true
		if facingDirection == 0:
			velocity.x = 0
		velocity.y = jumpStrength
		AudioManager.play_sound("res://Assets/Sounds/jump.wav",-40.0)
		animationPlayer.play("Jump")



func serialize() -> Dictionary:
	return {
		"HP": HP,
		"money": money,
		"canHeal": canHeal,
		"canAttack": canAttack,
		"lastCheckPoint": lastCheckPoint,
		"lastTilemap":lastTilemap,
		"lastSavedSong":OnRespawnSong,
		"inventory": inventory.serialize()
	}
