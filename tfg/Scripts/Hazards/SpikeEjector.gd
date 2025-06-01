class_name SpikeEjector extends Area2D

@export var damage = 10

func getDamage()-> int:
	return damage

func _ready() -> void:
	$CollisionShape2D.disabled = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		$CollisionShape2D.call_deferred("set_disabled", false)
		$AnimatedSprite2D.play("default")
		await $AnimatedSprite2D.animation_finished
		$CollisionShape2D.call_deferred("set_disabled", true)
		
