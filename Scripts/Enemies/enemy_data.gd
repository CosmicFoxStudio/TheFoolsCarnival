extends Resource

class_name EnemyResource

@export var health : float
@export var damage : float
@export var speed : float

@export var attack_sheet: Animation


func _set_attack_sheet(object: EnemyBase):
	object.animationPlayer.play()
	pass
