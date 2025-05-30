extends Control


@onready var slotButtons := [$Slot0, $Slot1, $Slot2]

var cursorReference: bool = false
var buttonReference: int = 0

var custom_cursor: Sprite2D
var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")
var current_input_mode := InputMode.MOUSE
enum InputMode { MOUSE, GAMEPAD }
@export var gamepad_speed: float = 500.0


func _ready():
	_setup_cursor()
	Input.connect("joy_connection_changed", _joy_connection_changed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	# Mostrar estado de cada partida
	##for i in range(3):
	##	if FileAccess.file_exists("user://gamefile%d.save" % i):
	##		var data = FileUtils.load_game(i)
	##		var tutorial_done = data.get("tutorialDone", false)
	##		slotButtons[i].text = "Partida %d - Tutorial: %s" % [i + 1, "✔" if tutorial_done else "❌"]
	##	else:
	##		slotButtons[i].text = "Partida %d - Vacía" % [i + 1]
	
	pass

func _setup_cursor():
	custom_cursor = Sprite2D.new()
	custom_cursor.texture = cursor_texture
	custom_cursor.name = "MenuCursor"
	custom_cursor.z_index = 1000
	custom_cursor.process_mode = PROCESS_MODE_ALWAYS
	custom_cursor.global_position = get_global_mouse_position()

	# Crear el Area2D y CollisionShape2D como hijos del cursor
	var cursor_area := Area2D.new()
	cursor_area.name = "CursorArea"
	cursor_area.collision_layer = 31 
	cursor_area.collision_mask = 30  

	var cursor_shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 5
	cursor_shape.shape = circle
	cursor_shape.name = "CursorCollisionShape"
	cursor_shape.position = Vector2(-5, -5)

	cursor_area.add_child(cursor_shape)
	custom_cursor.add_child(cursor_area)

	get_node("CanvasLayer").add_child(custom_cursor)
	$CanvasLayer.get_node("MenuCursor").global_position = Vector2(0,0)

func _joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		print("Mando conectado:", device_id)
		_set_input_mode(InputMode.GAMEPAD)
	else:
		print("Mando desconectado:", device_id)
		_set_input_mode(InputMode.MOUSE)


func _process(delta: float) -> void:
	if not custom_cursor:
		return
	
	var mouse_pos = get_global_mouse_position()
	if current_input_mode == InputMode.MOUSE:
		if custom_cursor.global_position != mouse_pos:
			custom_cursor.global_position = mouse_pos

	if current_input_mode == InputMode.GAMEPAD:
		var input_vector = Vector2(
			Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
			Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		)
		
		if input_vector.length() > 0.2:
			Input.set_custom_mouse_cursor(cursor_texture)
			custom_cursor.global_position += input_vector * gamepad_speed * delta
			custom_cursor.global_position = custom_cursor.global_position.clamp(Vector2.ZERO, get_viewport_rect().size)


func _set_input_mode(mode: InputMode):
	if current_input_mode == mode:
		return
	current_input_mode = mode
	if mode == InputMode.MOUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif mode == InputMode.GAMEPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_slot_pressed(slot_index: int):
	GameManager.currentSaveFile = slot_index
	GameManager.isLoadingGame = true
	get_tree().change_scene_to_file("res://scenes/World.tscn") 
