class_name LevelController extends Scene

## This controller handles connection between nodes in the level scenes

# These variables are specific to each instance of the LevelController
@export var _player : CharacterBody2D
@export var _HUD : UI
# @export var areaMarkers : Array[Line2D]  # List of area boundary markers (Marker2D)

@export var camLimiters : Array[Node2D] # List of camera limiters

@export_file("*.ogg") var _music : String = "res://assets/audio/music/mus_default.ogg"

var score : int = 0
var enemies := 0
var currentSegmentIndex: int = 1
var lastArea : bool = false

# Static variables persist across instances and scene changes
# ideal for global data management, utility functions, and ensuring a single data copy 
# These variables can be accessed directly from the class without creating a new instance
static var player: CharacterBody2D 
static var HUD: UI
static var music: String

# Runs before ready
func _enter_tree() -> void:
	player = _player
	HUD = _HUD
	music = _music
	
	Global.level = self
	Global.audio.currentStage = self
	Global.audio.currentStageName = get_name()
	Global.audio.currentMusic = music

func _ready():
	# Set to first limiter
	player.camera.limit_left = 0
	player.camera.limitManager.SetLimiter(camLimiters[currentSegmentIndex], false)
	
	# Global.audio.UpdateLevelMusic() 
	# (FIX ME) |---> Not working when the cutscene is skipped? Seems like it only adds the song to the playlist

# Update camera limits based on the current segment
func UpdateCameraLimits() -> void:
	# DEBUG 1
	# print("Limit Left: %s, Limit Right: %s, Limit Top: %s, Limit Bottom: %s" % [player.camera.limit_left, player.camera.limit_right, player.camera.limit_top, player.camera.limit_bottom])
	
	if currentSegmentIndex < camLimiters.size():
		# var old_limit = camLimiters[currentSegmentIndex - 1].position.x
		var new_limit = camLimiters[currentSegmentIndex].position.x
		print("New Limit: ", new_limit)
		
		# Smoothly transition the camera limit_right using a tween
		var tween := create_tween()

		# Start the interpolation
		tween.tween_property(
			player.camera,
			"limit_right",
			new_limit,
			1.0  # Duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		player.camera.limitManager.SetLimiter(camLimiters[currentSegmentIndex], false)
	else:
		print("Invalid segment index or camLimiters not configured.")
	
	# DEBUG 2
	# print("Limit Left: %s, Limit Right: %s, Limit Top: %s, Limit Bottom: %s" % [player.camera.limit_left, player.camera.limit_right, player.camera.limit_top, player.camera.limit_bottom])

func EnemyDied() -> void:
	enemies -= 1
	print("Enemy defeated! Remaining enemies:", enemies)

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
	
	# Normal Segment
	if currentSegmentIndex < camLimiters.size() - 1:
		UpdateCameraLimits()
		ConfigNextArea(enemies)
	# Reached BOSS
	elif currentSegmentIndex == camLimiters.size() - 1:
		Global.level.lastArea = true
		Global.debug.DebugPrint("Reached Last Area")
		UpdateCameraLimits()
		ConfigNextArea(enemies)
		
		# Pause Current Music
		Global.audio.musicPlayer.stop()
		
		# Play Boss Music
		Global.audio.musicPlayer.stream = load("res://assets/audio/music/boss_fight.mp3")
		Global.audio.musicPlayer.play()
	else: 
		currentSegmentIndex = camLimiters.size()

# Configure the next area's enemy count
func ConfigNextArea(__amount: int) -> void:
	enemies = __amount

#func GetCurrentSegmentBoundary() -> Vector2: return camLimiters[currentSegmentIndex].position

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
	Global.debug.UpdateDebugVariable(6, "[LEVEL] Enemies in Area: " + str(enemies))
	Global.debug.UpdateDebugVariable(7, "[LEVEL] Last Area?: " + str(lastArea))
	# Global.debug.UpdateDebugVariable(19, "[LEVEL] Segment 0: " + str(areaMarkers[0].position.x))
	Global.debug.UpdateDebugVariable(8, "[LEVEL] Segment Index: " + str(currentSegmentIndex))
	# Camera Stuff
	Global.debug.UpdateDebugVariable(9, "[LEVEL] Camera Pos: " + str(player.camera.position))

	#Global.debug.UpdateDebugVariable(10, "[LEVEL] Camera Clamped Pos: " + str(camera.clampedPos)) 
	#Global.debug.UpdateDebugVariable(11, "[LEVEL] Camera Clamped New Pos: " + str(camera.targetClampedPos))
