class_name InventoryUI extends Control

@onready var inventory: Inventory = preload("res://Scenes/Inventory/PlayerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var attackSlot: InventoryUISlot = $AttackSlot
@onready var abilitySlot: InventoryUISlot = $AbilitySlot
@onready var healthSlot: InventoryUISlot = $HealthSlot

signal InventoryOpen
signal InventoryClosed

var isOpen = false
var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")

# Input Mode
enum InputMode { MOUSE, GAMEPAD }
var current_input_mode := InputMode.MOUSE
@export var gamepad_speed: float = 500.0

func _ready() -> void:
	inventory.update.connect(updateSlots)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	center_on_screen()
	get_viewport().connect("size_changed", center_on_screen)
	close()

func center_on_screen():
	var viewport_size = get_viewport_rect().size
	position = (viewport_size - size) * 0.5

func updateSlots() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
		
	healthSlot.update(inventory.slots[9])
	attackSlot.update(inventory.slots[10])
	abilitySlot.update(inventory.slots[11])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_set_input_mode(InputMode.MOUSE)
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		_set_input_mode(InputMode.GAMEPAD)

func _set_input_mode(mode: InputMode):
	if current_input_mode == mode:
		return
	current_input_mode = mode
	if mode == InputMode.MOUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif mode == InputMode.GAMEPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if isOpen:
			close()
			GameManager.inventoryClosed()
		else:
			open()
			GameManager.inventoryOpen()

func open() -> void:
	visible = true
	isOpen = true
	z_index = 2
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	emit_signal("InventoryOpen")

func close() -> void:
	visible = false
	isOpen = false
	if !GameManager.isShopInScreen : Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	emit_signal("InventoryClosed")


func _on_inv_slot_pressed(index: int) -> void:
	inventory.equip_gem_on_double_click(index)
