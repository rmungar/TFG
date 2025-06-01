extends Control

@onready var playButton: TextureButton = $CharacterBody2D/Buttons/Play
@onready var optionsButton: TextureButton = $CharacterBody2D/Buttons/Options
@onready var creditsButton: TextureButton = $CharacterBody2D/Buttons/Credits
@onready var quitButton: TextureButton = $CharacterBody2D/Buttons/Quit

# Cursor Management
var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")
var current_input_mode := InputMode.MOUSE
enum InputMode { MOUSE, GAMEPAD }
@export var gamepad_speed: float = 500.0

func _ready() -> void:
	_update_button_visibility()
	# Usamos el cursor nativo con imagen personalizada
	#Input.set_custom_mouse_cursor(cursor_texture)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _update_button_visibility():
	playButton.visible = not playButton.disabled
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
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 30 * delta
	if current_input_mode == InputMode.GAMEPAD:
		var input_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		if input_vector.length() > 0.2:
			get_viewport().warp_mouse(round(get_global_mouse_position() * input_vector * gamepad_speed * delta))


func onPlayButtonPressed():
	GameManager.toSaveFilesScreen()

func onOptionsButtonPressed():
	GameManager.toOptionsScreen()

func onCreditsButtonPressed():
	GameManager.toCreditsScreen()

func onQuitButtonPressed():
	GameManager.QuitGame()
