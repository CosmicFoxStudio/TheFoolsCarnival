class_name EnemyResource extends Resource

@export var health : float
@export var damage : float
@export var speed : float
@export var attack_sheet: Animation
@export var enemyType : Util.ENEMY_TYPES

func _set_attack_sheet(object: EnemyBase):
	object.animationPlayer.play()
