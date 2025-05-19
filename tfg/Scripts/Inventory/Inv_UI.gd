class_name InventoryUI extends Control

@onready var inventory: Inventory = preload("res://Scenes/Inventory/PlayerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

signal InventoryOpen
signal InventoryClosed

var isOpen = false
var custom_cursor: Sprite2D
var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png") 

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

func center_on_screen():
	var viewport_size = get_viewport_rect().size
	position = (viewport_size - size) * 0.5

func updateSlots() -> void:
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if isOpen:
			close()
			GameManager.inventoryClosed()
		else:
			open()
			GameManager.inventoryOpen()
	if isOpen and custom_cursor:
		custom_cursor.global_position = get_viewport().get_mouse_position()

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
		custom_cursor.z_index = RenderingServer.CANVAS_ITEM_Z_MAX  
	emit_signal("InventoryClosed")

func _exit_tree():
	# Clean up cursor when inventory UI is destroyed
	if custom_cursor and is_instance_valid(custom_cursor):
		custom_cursor.queue_free()
