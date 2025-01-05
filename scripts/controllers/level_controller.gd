class_name LevelController extends Scene

## This controller handles connection between nodes in the level scenes

@export var _player : CharacterBody2D
@export var _camera : Camera2D
@export var _HUD : UI
#@export var _audience_meter : AudienceMeter

var score : int = 0

# Static variables persist across instances and scene changes
# ideal for global data management, utility functions, and ensuring a single data copy 
# These variables can be accessed directly from the class without creating a new instance
static var player: CharacterBody2D 
#static var audience_meter : AudienceMeter
static var camera: Camera2D
static var HUD: UI

var enemies := 0
var unlockedAtArea := 0.0
var lastArea : bool = false

# Runs before ready
func _enter_tree() -> void:
	Global.audioManager.current_stage = "Stage1" # Change it to a Data Structure (Dictionary)
	Global.level = self

	player = _player
	camera = _camera
	HUD = _HUD
	#audience_meter = _audience_meter

func _ready():
	Global.level = self
	#audience_meter.on_meter_reached_zero.connect(EndGame)

func EnemyDied() -> void:
	enemies -= 1
	print("Enemy defeated!")
	
	# audience_meter.add_meter(enemy.score_value * 0.1)
	# score += enemy.scoreValue
	
	if lastArea: 
		# Ends the game if level is cleared
		HUD.LevelCleared()
		return
		
	if enemies <= 0:
		HUD.ShowGo()
		NextArea(unlockedAtArea)

func NextArea(__cameraLimit: float) -> void:
	Global.level.camera.SetCameraLimit(__cameraLimit)

func ConfigNextArea(__amount: int, __unlocked: float) -> void:
	enemies = __amount
	unlockedAtArea = __unlocked

func EndGame():
	print("GAME OVER")

	# if gameOverScene: # is loaded
		# var game_over_instance = gameOverScene.instantiate()
		# get_tree().root.add_child(game_over_instance)
		
		# (TO-DO), Add the scene as a child of a dedicated Control or CanvasLayer node
		# var ui_layer = get_tree().current_scene.get_node("UILayer")
		# ui_layer.add_child(game_over_instance)
