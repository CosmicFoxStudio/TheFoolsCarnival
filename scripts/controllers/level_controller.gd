class_name LevelController extends Scene

## This controller handles connection between nodes in the level scenes

@export var _player : CharacterBody2D
# @export var _camera: Camera2D
# @export var _HUD: UI
@export var _audience_meter : AudienceMeter

@export var _instances : Array[RigidBody2D]
@export var _enemiesToSpawn : Array[PackedScene]
@export var _spawnPositions: Array[Node2D]
@export var _spawnTimer : Timer

var score:int = 0

# Static variables persist across instances and scene changes
# ideal for global data management, utility functions, and ensuring a single data copy 
# These variables can be accessed directly from the class without creating a new instance
static var player: CharacterBody2D 
static var audience_meter : AudienceMeter
static var instances : Array[RigidBody2D]
static var enemiesToSpawn : Array[PackedScene]
static var spawnPositions: Array[Node2D]
static var spawnTimer : Timer
# static var camera: Camera2D
# static var HUD: UI

# Runs before ready
func _enter_tree() -> void:
	Global.audioManager.current_stage = "Stage1" # Change it to a Data Structure (Dictionary)
	Global.level = self

	player = _player
	# camera = _camera
	# HUD = _HUD
	audience_meter = _audience_meter
	instances = _instances
	enemiesToSpawn = _enemiesToSpawn
	spawnPositions = _spawnPositions
	spawnTimer = _spawnTimer

func _ready():
	Global.level = self

	for instance in instances:
		#var enemy = instance as EnemyBase
		instance.connect("enemy_dead", _on_enemy_dead)

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
	print("Enemy defeated!")
	audience_meter.add_meter(enemy.score_value * 0.1)
	score += enemy.score_value

func _end_game():
	print("GAME OVER")

	# if gameOverScene: # is loaded
		# var game_over_instance = gameOverScene.instantiate()
		# get_tree().root.add_child(game_over_instance)
		
		# (TO-DO), Add the scene as a child of a dedicated Control or CanvasLayer node
		# var ui_layer = get_tree().current_scene.get_node("UILayer")
		# ui_layer.add_child(game_over_instance)
