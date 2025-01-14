class_name UI extends CanvasLayer

var score: int = 0

# Go
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

# DramaMeter
@onready var dramaMeter: DramaMeter = $UIGameplay/DramaMeter

# Audience
@onready var audience: Control = $UIGameplay/Audience

# Player
@onready var hudPlayer: Control = $UIGameplay/HUDPlayer
@onready var namePlayer: Label = $UIGameplay/HUDPlayer/NamePlayer
@onready var healthPlayer: TextureProgressBar = $UIGameplay/HUDPlayer/HealthPlayer
@onready var portraitPlayer: TextureRect = $UIGameplay/HUDPlayer/PortraitPlayer
@onready var scorePlayer: Label = $UIGameplay/HUDPlayer/ScorePlayer

# Enemy
@onready var hudEnemy: Control = $UIGameplay/HUDEnemy
@onready var nameEnemy: Label = $UIGameplay/HUDEnemy/NameEnemy
@onready var healthEnemy: TextureProgressBar = $UIGameplay/HUDEnemy/HealthEnemy
@onready var portraitEnemy: TextureRect = $UIGameplay/HUDEnemy/PortraitEnemy
@onready var timerEnemyUI: Timer = $TimerEnemyUI

func _ready() -> void:
	hudEnemy.hide()
	UpdateScoreLabel()

func AddScore(points: int):
	var multiplier = GetDramaMeterMultiplier()
	var pointsToAdd = points * multiplier

	# Update score
	score += int(pointsToAdd)
	UpdateScoreLabel()

func GetDramaMeterMultiplier() -> float:
	match dramaMeter.GetAudienceLevel():
		"Red": return 0.5
		"Orange": return 1.0
		"Yellow": return 1.5
		"Green": return 2.0
		"Blue": return 3.0
		_: return 1.0  # Default multiplier

# Helper function to format score to always display as a 5-digit number
# For example: Score 50 -> 00050
func UpdateScoreLabel():
	scorePlayer.text = str(score).pad_zeros(5)

func HudUpdateHealth(__hp: float) -> void:
	healthPlayer.value = __hp

func HudUpdatePlayer(__properties: CharacterData) -> void:
	namePlayer.text = __properties.name
	healthPlayer.value = __properties.hpMax
	healthPlayer.max_value = __properties.hpMax
	portraitPlayer.texture = __properties.portrait

func HudUpdateEnemy(__properties: CharacterData, __enemyHP: float) -> void:
	nameEnemy.text = __properties.name
	healthEnemy.value = __enemyHP
	healthEnemy.max_value = __properties.hpMax
	portraitEnemy.texture = __properties.portrait
	
	hudEnemy.show()
	timerEnemyUI.stop()
	timerEnemyUI.start()
	
	await timerEnemyUI.timeout
	hudEnemy.hide()

func ShowGo() -> void:
	animationPlayer.play("go")
	await get_tree().create_timer(2).timeout
	animationPlayer.stop()
	$Go.hide()

func LevelCleared() -> void:
	Global.audio.SetMusic("LevelCleared")
	Global.audio.SetSFX("CrowdApplause")

	# Stop Player Movement (TO-DO: We need a pause system)
	Global.pause = true

	# Show Level Cleared
	var hudLevelCleared = $UIGameplay/HUDLevelCleared
	hudLevelCleared.show()
	var levelClearMusic = $UIGameplay/HUDLevelCleared/LevelClearedJingle
	levelClearMusic.play()
	
	# Timer
	await get_tree().create_timer(5).timeout
	
	# Change back to menu
	Global.sceneTransition.transition(
		"res://scenes/screens/menu_interface.tscn", 
		Global.sceneTransition.TransitionType.FADE
	)
