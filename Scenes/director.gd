extends Node
class_name Director

@export var instances:Array[RigidBody2D]
@export var audience_meter:AudienceMeter

var score:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for instance in instances:
		var enemy = instance as EnemyBase
		instance.connect("enemy_dead", _on_enemy_dead)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enemy_dead(enemy:EnemyBase):
	audience_meter.add_meter(enemy.score_value * 0.1)
	score += enemy.score_value
