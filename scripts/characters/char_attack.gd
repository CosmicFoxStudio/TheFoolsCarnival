extends Area2D

class_name AttackArea2D

@export var atkShape : CollisionShape2D

var index = 0
var attack_damage = 10

func set_attack_damage(dmg:float) -> void:
	attack_damage = dmg

func _on_character_attack_body_entered(_body: Node2D) -> void:
	pass
	#body._take_damage(attack_damage)

func _on_timer_timeout() -> void:
	#process_mode = PROCESS_MODE_DISABLED[
	pass
