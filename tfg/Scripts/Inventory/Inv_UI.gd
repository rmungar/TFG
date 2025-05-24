class_name InventoryUI extends Control

@onready var inventory: Inventory = preload("res://Scenes/Inventory/PlayerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var attackSlot: InventoryUISlot = $AttackSlot
@onready var abilitySlot: InventoryUISlot = $AbilitySlot
@onready var healthSlot: InventoryUISlot = $HealthSlot

signal InventoryOpen
signal InventoryClosed

var isOpen = false
var custom_cursor: Sprite2D
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
	_setup_cursor()
	close()

func _setup_cursor():
	custom_cursor = Sprite2D.new()
	custom_cursor.texture = cursor_texture
	custom_cursor.name = "InventoryCursor"
	custom_cursor.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
	custom_cursor.process_mode = PROCESS_MODE_ALWAYS
	add_child.call_deferred(custom_cursor)
	custom_cursor.visible = false
	custom_cursor.global_position = get_viewport().get_mouse_position()

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
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if isOpen:
			close()
			GameManager.inventoryClosed()
		else:
			open()
			GameManager.inventoryOpen()

	if isOpen and custom_cursor:
		match current_input_mode:
			InputMode.MOUSE:
				custom_cursor.global_position = get_viewport().get_mouse_position()
			InputMode.GAMEPAD:
				var input_vector = Vector2(
					Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
					Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
				)
				if input_vector.length() > 0.2:
					custom_cursor.global_position += input_vector * gamepad_speed * delta
					custom_cursor.global_position = custom_cursor.global_position.clamp(
						position,  # top-left of inventory
						position + size  # bottom-right of inventory
					)

func open() -> void:
	visible = true
	isOpen = true
	z_index = 2
	if custom_cursor:
		custom_cursor.visible = true
	emit_signal("InventoryOpen")

func close() -> void:
	visible = false
	isOpen = false
	if custom_cursor:
		custom_cursor.visible = false
	emit_signal("InventoryClosed")

func _exit_tree():
	if custom_cursor and is_instance_valid(custom_cursor):
		custom_cursor.queue_free()
