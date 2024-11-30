class_name Hitbox extends Area2D

@onready var host : Node2D = get_parent()
@onready var health : Health = get_parent().get_node("Health")

func __take_damage(damage: float) -> void: 
	if health:
		health.__take_damage(damage)
