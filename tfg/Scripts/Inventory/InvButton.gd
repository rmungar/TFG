class_name InvButton extends Button

signal Pressed(index: int)

var click_timer := 0.0
var click_threshold := 0.3
var last_click_time := 0.0


func _on_pressed() -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_click_time <= click_threshold:
		Pressed.emit(get_parent().index)
	last_click_time = current_time
