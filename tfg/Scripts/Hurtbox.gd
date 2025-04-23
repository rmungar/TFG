class_name Hurtbox extends Area2D

signal hurt(damage: int)

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Area2D):
	if hitbox.has_method("get_damage"):  
		hurt.emit(hitbox.get_damage())
