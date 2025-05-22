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
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _setup_cursor():
	custom_cursor = Sprite2D.new()
	custom_cursor.texture = cursor_texture
	custom_cursor.name = "MenuCursor"
	custom_cursor.z_index = 1000
	custom_cursor.process_mode = PROCESS_MODE_ALWAYS
	get_node("CanvasLayer").add_child(custom_cursor)
	custom_cursor.global_position = get_global_mouse_position()

func _update_button_visibility():
	playButton.visible = not playButton.disabled
	continueButton.visible = not continueButton.disabled
	optionsButton.visible = not optionsButton.disabled
	creditsButton.visible = not creditsButton.disabled
	quitButton.visible = not quitButton.disabled

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
	if not custom_cursor:
		return
	print("Mouse Pos: ", get_global_mouse_position(), " | Cursor Pos: ", custom_cursor.global_position)
	if current_input_mode == InputMode.MOUSE:
		custom_cursor.global_position = get_global_mouse_position() - Vector2(50, 0)
	elif current_input_mode == InputMode.GAMEPAD:
		var input_vector = Vector2(
			Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		)

		if input_vector.length() > 0.2:
			custom_cursor.global_position += input_vector * gamepad_speed * delta
			custom_cursor.global_position = custom_cursor.global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func onPlayButtonPressed():
	GameManager.toTutorialScreen()

func onOptionsButtonPressed():
	GameManager.toOptionsScreen()

func onCreditsButtonPressed():
	GameManager.toCreditsScreen()

func onQuitButtonPressed():
	GameManager.QuitGame()

func onContinueButtonPressed() -> void:
	pass # Replace with function body.

func _exit_tree():
	if custom_cursor and is_instance_valid(custom_cursor):
		custom_cursor.queue_free()
