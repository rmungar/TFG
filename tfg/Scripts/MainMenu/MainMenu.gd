extends Control

@onready var playButton: TextureButton = $CharacterBody2D/Buttons/Play
@onready var continueButton: TextureButton = $CharacterBody2D/Buttons/Continue
@onready var optionsButton: TextureButton = $CharacterBody2D/Buttons/Options
@onready var creditsButton: TextureButton = $CharacterBody2D/Buttons/Credits
@onready var quitButton: TextureButton = $CharacterBody2D/Buttons/Quit

# Cursor Management
var custom_cursor: Sprite2D
var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")
var current_input_mode := InputMode.MOUSE
enum InputMode { MOUSE, GAMEPAD }
@export var gamepad_speed: float = 500.0

func _ready() -> void:
	_update_button_visibility()
	_setup_cursor()
	Input.connect("joy_connection_changed", _joy_connection_changed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Asegúrate que el CanvasLayer no sigue el viewport si está afectando

func _joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		print("Mando conectado:", device_id)
		# Podrías forzar modo mando o no hacer nada
	else:
		print("Mando desconectado:", device_id)
		_set_input_mode(InputMode.MOUSE)


func _update_button_visibility():
	playButton.visible = not playButton.disabled
	continueButton.visible = not continueButton.disabled
	optionsButton.visible = not optionsButton.disabled
	creditsButton.visible = not creditsButton.disabled
	quitButton.visible = not quitButton.disabled

func _setup_cursor():
	custom_cursor = Sprite2D.new()
	custom_cursor.texture = cursor_texture
	custom_cursor.name = "MenuCursor"
	custom_cursor.z_index = 1000
	custom_cursor.process_mode = PROCESS_MODE_ALWAYS
	# Si quieres evitar que el sprite bloquee input (en Control usar mouse_filter)
	# Aquí Sprite2D no bloquea, pero si usas Control, haz: mouse_filter = MOUSE_FILTER_IGNORE
	get_node("CanvasLayer").add_child(custom_cursor)
	custom_cursor.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	print(event.get_class())
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		print("Mouse input detected")
		_set_input_mode(InputMode.MOUSE)
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		print("Gamepad input detected")
		_set_input_mode(InputMode.GAMEPAD)

func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 30 * delta  
	if not custom_cursor:
		return

	var mouse_pos = get_global_mouse_position()
	if current_input_mode == InputMode.MOUSE:
		if custom_cursor.global_position != mouse_pos:
			custom_cursor.global_position = mouse_pos
	else:
		# Si en modo gamepad pero detectamos movimiento de ratón, cambiar a modo ratón
		if mouse_pos.distance_to(custom_cursor.global_position) > 1:
			_set_input_mode(InputMode.MOUSE)

	if current_input_mode == InputMode.GAMEPAD:
		var input_vector = Vector2(
			Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		)
		if input_vector.length() > 0.2:
			custom_cursor.global_position += input_vector * gamepad_speed * delta
			custom_cursor.global_position = custom_cursor.global_position.clamp(Vector2.ZERO, get_viewport_rect().size)
			Input.warp_mouse(custom_cursor.global_position)


func _set_input_mode(mode: InputMode):
	if current_input_mode == mode:
		return
	current_input_mode = mode
	if mode == InputMode.MOUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif mode == InputMode.GAMEPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
