class_name UI extends CanvasLayer

# Go
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

# Player
@onready var hudPlayer: Control = $UIGameplay/HUDPlayer
@onready var namePlayer: Label = $UIGameplay/HUDPlayer/NamePlayer
@onready var healthPlayer: ProgressBar = $UIGameplay/HUDPlayer/HealthPlayer
@onready var portraitPlayer: TextureRect = $UIGameplay/HUDPlayer/PortraitPlayer

# Enemy
@onready var hudEnemy: Control = $UIGameplay/HUDEnemy
@onready var nameEnemy: Label = $UIGameplay/HUDEnemy/NameEnemy
@onready var healthEnemy: ProgressBar = $UIGameplay/HUDEnemy/HealthEnemy
@onready var portraitEnemy: TextureRect = $UIGameplay/HUDEnemy/PortraitEnemy
@onready var timerEnemyUI: Timer = $TimerEnemyUI

func _ready() -> void:
	# Global.level.HUD = self
	hudEnemy.hide()

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
	# Pause level music
	Global.audio.musicPlayer.stop()

	#Global.audio.musicPlayer.stream = load("res://assets/audio/music/boss_fight.mp3")
	#Global.audio.musicPlayer.play()

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
