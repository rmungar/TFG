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
	close()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
	get_tree().paused = false


func _on_save_pressed() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	$Sprite2D.visible = true
	GameManager.onSave(player, GameManager.tutorial_done)
	await get_tree().create_timer(1).timeout
	$Sprite2D.visible = false


func _on_quit_pressed() -> void:
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
