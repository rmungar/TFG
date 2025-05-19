extends Control

@onready var playButton: TextureButton = $CharacterBody2D/Buttons/Play
@onready var continueButton: TextureButton = $CharacterBody2D/Buttons/Continue
@onready var optionsButton: TextureButton = $CharacterBody2D/Buttons/Options
@onready var creditsButton: TextureButton = $CharacterBody2D/Buttons/Credits
@onready var quitButton: TextureButton = $CharacterBody2D/Buttons/Quit

# Cursor Management
var custom_cursor: Sprite2D
var cursor_texture = preload("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png") # Set your cursor texture path

func _ready() -> void:
	# Initialize button visibility
	_update_button_visibility()
	
	# Set up custom cursor
	_setup_cursor()
	
	# Ensure cursor is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _setup_cursor():
	# Create CanvasLayer for cursor
	var cursor_layer = CanvasLayer.new()
	cursor_layer.layer = 100  # Higher than menu elements
	add_child(cursor_layer)
	
	# Create cursor sprite
	custom_cursor = Sprite2D.new()
	custom_cursor.texture = cursor_texture
	custom_cursor.name = "MenuCursor"
	custom_cursor.z_index = 1000  # Highest priority
	custom_cursor.process_mode = PROCESS_MODE_ALWAYS
	
	# Add to canvas layer
	$CanvasLayer.add_child(custom_cursor)
	
	# Position cursor at mouse location
	custom_cursor.global_position = get_global_mouse_position()

func _update_button_visibility():
	if playButton.disabled:
		playButton.visible = false
	if continueButton.disabled:
		continueButton.visible = false
	if optionsButton.disabled:
		optionsButton.visible = false
	if creditsButton.disabled:
		creditsButton.visible = false
	if quitButton.disabled:
		quitButton.visible = false

func _process(delta: float) -> void:
	# Update cursor position continuously
	if custom_cursor:
		custom_cursor.global_position = get_global_mouse_position() + Vector2(5,0)

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
	# Clean up cursor when menu is destroyed
	if custom_cursor and is_instance_valid(custom_cursor):
		custom_cursor.queue_free()
