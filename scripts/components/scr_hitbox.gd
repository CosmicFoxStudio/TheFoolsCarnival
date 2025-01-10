class_name Hitbox extends Area2D

@onready var host : Node2D = get_parent()
@onready var health : Health = get_parent().get_node("Health")

func TakeDamage(damage: float) -> void: 
	if health:
		health.TakeDamage(damage)
