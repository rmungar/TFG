extends Control

@onready var playButton: TextureButton = $CharacterBody2D/Buttons/Play
@onready var continueButton: TextureButton = $CharacterBody2D/Buttons/Continue
@onready var optionsButton: TextureButton = $CharacterBody2D/Buttons/Options
@onready var creditsButton: TextureButton = $CharacterBody2D/Buttons/Credits
@onready var quitButton: TextureButton = $CharacterBody2D/Buttons/Quit

var cursorReference: bool = false
var buttonReference: int = 0

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

func _joy_connection_changed(device_id: int, connected: bool) -> void:
	if connected:
		print("Mando conectado:", device_id)
	else:
		print("Mando desconectado:", device_id)
		_set_input_mode(InputMode.MOUSE)

func _update_button_visibility():
	playButton.visible = not playButton.disabled
	continueButton.visible = not continueButton.disabled
	optionsButton.visible = not optionsButton.disabled
	creditsButton.visible = not creditsButton.disabled
	quitButton.visible = not quitButton.disabled

####################################################################################################

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if current_input_mode != InputMode.MOUSE:
			print("Mouse input detected")
			_set_input_mode(InputMode.MOUSE)
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:
		if current_input_mode != InputMode.GAMEPAD:
			print("Gamepad input detected")
			_set_input_mode(InputMode.GAMEPAD)

func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 30 * delta  
	if not custom_cursor:
		return
	
	if cursorReference and buttonReference != 0:
		if Input.is_action_just_pressed("Interact"):
			match buttonReference:
				1: onPlayButtonPressed()
				2: onContinueButtonPressed()
				3: onOptionsButtonPressed()
				4: onCreditsButtonPressed()
				5: onQuitButtonPressed()
	
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
			custom_cursor.global_position += input_vector * gamepad_speed * delta
			custom_cursor.global_position = custom_cursor.global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func _set_input_mode(mode: InputMode):
	if current_input_mode == mode:
		return
	current_input_mode = mode
	if mode == InputMode.MOUSE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif mode == InputMode.GAMEPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

####################################################################################################

func onPlayButtonPressed(): GameManager.toTutorialScreen()
func onOptionsButtonPressed(): GameManager.toOptionsScreen()
func onCreditsButtonPressed(): GameManager.toCreditsScreen()
func onQuitButtonPressed(): GameManager.QuitGame()
func onContinueButtonPressed() -> void: pass

####################################################################################################

func _on_play_area_2d_area_entered(body: Area2D) -> void:
	print(body)
	if body.name == "CursorArea":
		cursorReference = true
		buttonReference = 1

func _on_continue_area_2d_area_entered(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = true
		buttonReference = 2

func _on_play_options_2d_area_entered(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = true
		buttonReference = 3

func _on_play_credits_2d_area_entered(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = true
		buttonReference = 4

func _on_play_quit_2d_area_entered(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = true
		buttonReference = 5

func _on_play_area_2d_area_exited(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = false
		buttonReference = 0

func _on_continue_area_2d_area_exited(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = false
		buttonReference = 0

func _on_play_options_2d_area_exited(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = false
		buttonReference = 0

func _on_credits_area_2d_area_exited(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = false
		buttonReference = 0

func _on_quit_area_2d_area_exited(body: Area2D) -> void:
	if body.name == "CursorArea":
		cursorReference = false
		buttonReference = 0
