class_name PauseMenu extends Control


func _ready() -> void:
	visible = false
	center_on_screen()


func _process(delta: float) -> void:
	$Sprite2D.visible = false
	if !visible and Input.is_action_just_pressed("Pause"):
		open()
	elif visible and Input.is_action_just_pressed("Pause"):
		close()


func _on_continue_pressed() -> void:
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	close()


func _on_main_menu_pressed() -> void:
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	GameManager.counting = false
	ApiHelper.get_all_players()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")


func _on_quit_pressed() -> void:
	AudioManager.play_sound("res://Assets/Sounds/ButtonClick.wav")
	get_tree().quit()


func center_on_screen():
	var viewport_size = get_viewport_rect().size
	position = (viewport_size - size) * 0.5


func open():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true


func close():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false
