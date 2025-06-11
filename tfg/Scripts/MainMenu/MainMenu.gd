extends Control

@onready var playButton: TextureButton = $CharacterBody2D/Buttons/Play
@onready var optionsButton: TextureButton = $CharacterBody2D/Buttons/Options
@onready var quitButton: TextureButton = $CharacterBody2D/Buttons/Quit


var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")
var current_input_mode := InputMode.MOUSE
enum InputMode { MOUSE, GAMEPAD }
@export var gamepad_speed: float = 500.0
var mainMenuMusicTracks: Array[String] = ["res://Assets/Sounds/EchoesFromTheFutureV1.mp3","res://Assets/Sounds/EchoesFromTheFutureV2.mp3"]

func _ready() -> void:
	GameManager.isInMainMenu = true
	AudioManager.cycle_music(mainMenuMusicTracks)
	_update_button_visibility()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	playButton.grab_focus()

func _update_button_visibility():
	playButton.visible = not playButton.disabled
	optionsButton.visible = not optionsButton.disabled
	quitButton.visible = not quitButton.disabled

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
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	GameManager.toSaveFilesScreen()

func onOptionsButtonPressed():
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	GameManager.toOptionsScreen()

func onQuitButtonPressed():
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	GameManager.QuitGame()
