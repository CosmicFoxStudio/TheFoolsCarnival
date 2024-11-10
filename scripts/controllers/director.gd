extends Node
class_name Director

@export var instances:Array[RigidBody2D]
@export var audience_meter:AudienceMeter

@export var player : CharacterBody2D

@export var enemiesToSpawn : Array[PackedScene]

@export var spawnPositions: Array[Node2D]
@export var spawnTimer : Timer

@export var gameOverScene : PackedScene

var score:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#for instance in instances:
		#var enemy = instance as EnemyBase
		#instance.connect("enemy_dead", _on_enemy_dead)
	
	audience_meter.on_meter_reached_zero.connect(_end_game)
	
	_spawn_enemies()

func _spawn_enemies() -> void:
	for pos in spawnPositions:
		var instance = enemiesToSpawn.pick_random().instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		instance.connect("enemy_dead", _on_enemy_dead)
		var enemy = instance as EnemyBase
		#enemy.set_player(player)
		
		enemy.transform.origin = pos.transform.origin
		pos.add_child(instance)
		
		
	await spawnTimer.timeout
	_spawn_enemies()
	
	
func _on_enemy_dead(enemy:EnemyBase):
	audience_meter.add_meter(enemy.score_value * 0.1)
	score += enemy.score_value

func _end_game():
	print("GAME OVER")

	if gameOverScene: # is loaded
		var game_over_instance = gameOverScene.instantiate()
		get_tree().root.add_child(game_over_instance)
		
		# (TO-DO), Add the scene as a child of a dedicated Control or CanvasLayer node
		# var ui_layer = get_tree().current_scene.get_node("UILayer")
		# ui_layer.add_child(game_over_instance)
