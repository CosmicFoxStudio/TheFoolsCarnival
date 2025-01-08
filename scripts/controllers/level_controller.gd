class_name LevelController extends Scene

## This controller handles connection between nodes in the level scenes

# These variables are specific to each instance of the LevelController
@export var _player : CharacterBody2D
@export var _camera : Camera2D
@export var _HUD : UI
@export var areaMarkers : Array[Line2D]  # List of area boundary markers (Marker2D)
@export_file("*.ogg") var _music : String = "res://assets/audio/music/mus_default.ogg"

var score : int = 0
var enemies := 0
var currentSegmentIndex: int = 0
var lastArea : bool = false

# Static variables persist across instances and scene changes
# ideal for global data management, utility functions, and ensuring a single data copy 
# These variables can be accessed directly from the class without creating a new instance
static var camera: Camera2D
static var player: CharacterBody2D 
static var HUD: UI
static var music: String

# Runs before ready
func _enter_tree() -> void:
	camera = _camera
	player = _player
	HUD = _HUD
	music = _music
	
	Global.level = self
	Global.audio.currentStage = self
	Global.audio.currentStageName = get_name()
	Global.audio.currentMusic = music

func _ready():
	UpdateCameraLimits()
	
	# Global.audio.UpdateLevelMusic() 
	# (FIX ME) |---> Not working when the cutscene is skipped? Seems like it only adds the song to the playlist
	
	# Global.level.HUD.dramaMeter.OnMeterReachedZero.connect(EndGame)
	# if Global.level.HUD.dramaMeter.IsStageFailed(): EndGame()

# Update camera limits based on the current segment
func UpdateCameraLimits() -> void:
	if currentSegmentIndex < areaMarkers.size():
		var limit = areaMarkers[currentSegmentIndex].position.x
		print("Limit: " + str(limit))
		# Update the horizontal limit
		Global.level.camera.SetCameraLimit(Vector2(limit, 0))
	else:
		print("Invalid segment index or areaMarkers not configured.")

func EnemyDied() -> void:
	enemies -= 1
	print("Enemy defeated! Remaining enemies:", enemies)
	
	# Global.level.HUD.dramaMeter.addMeter(enemy.scoreValue * 0.1)
	# score += enemy.scoreValue
	
	# Last Area has only one enemy, the Boss
	if lastArea: 
		# Ends the game if level is cleared
		HUD.LevelCleared()
		return
		
	# Check if enough enemies are defeated
	if enemies <= 0:
		HUD.ShowGo()
		AdvanceToNextSegment()

# Advance to the next segment and update camera limits
func AdvanceToNextSegment() -> void:
	currentSegmentIndex += 1
	camera.UpdateSegmentBoundary(GetCurrentSegmentBoundary())
	
	if currentSegmentIndex < areaMarkers.size():
		UpdateCameraLimits()
		ConfigNextArea(enemies)
	else:
		Global.level.lastArea = true
		Global.debug.DebugPrint("Reached Last Area")

# Configure the next area's enemy count
func ConfigNextArea(__amount: int) -> void:
	enemies = __amount

func GetCurrentSegmentBoundary() -> Vector2:
	return areaMarkers[currentSegmentIndex].get_point_position(1)

func EndGame():
	print("GAME OVER")

	# if gameOverScene: # is loaded
		# var game_over_instance = gameOverScene.instantiate()
		# get_tree().root.add_child(game_over_instance)
		
		# (TO-DO), Add the scene as a child of a dedicated Control or CanvasLayer node
		# var ui_layer = get_tree().current_scene.get_node("UILayer")
		# ui_layer.add_child(game_over_instance)

func _process(_delta: float) -> void: _debug()

# Debug Level
func _debug() -> void:
	Global.debug.UpdateDebugVariable(17, "[LEVEL] Enemies in Area: " + str(enemies))
	Global.debug.UpdateDebugVariable(18, "[LEVEL] Segment 0: " + str(areaMarkers[0].position.x))
	Global.debug.UpdateDebugVariable(19, "[LEVEL] Last Area?: " + str(lastArea))
