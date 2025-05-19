extends Node


var cursor_instance: Sprite2D
var is_cursor_visible := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  
	_setup_cursor()  

func _setup_cursor():
	
	cursor_instance = Sprite2D.new()
	cursor_instance.texture = load("res://Assets/Mouse/PNG/Basic/Default/pointer_b.png")
	cursor_instance.name = "CustomCursor"
	cursor_instance.z_index = 1000  
	cursor_instance.process_mode = PROCESS_MODE_ALWAYS  
	get_tree().root.add_child.call_deferred(cursor_instance)
	cursor_instance.visible = false  

func _process(_delta):
	if is_cursor_visible and cursor_instance:
		cursor_instance.global_position = get_viewport().get_mouse_position()

func _update_cursor_visibility():
	var should_show = GameManager.isInventoryOpen
	
	if should_show and not is_cursor_visible:
		if not cursor_instance:  
			_setup_cursor()
		cursor_instance.visible = true
		is_cursor_visible = true
		
	elif not should_show and is_cursor_visible:
		if cursor_instance:
			cursor_instance.visible = false
		is_cursor_visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func on_game_state_changed():
	_update_cursor_visibility()
