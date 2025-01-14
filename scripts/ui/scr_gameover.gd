extends Scene

@onready var animationPlayer : AnimationPlayer = $SelectionSequence
# @onready var gameoverSFX: AudioStreamPlayer = $GameOverSFXs

var dramaMeter : DramaMeter

func _ready() -> void:
	animationPlayer.play("gameover/start")
	Global.audio.musicPlayer.stop()
	
	dramaMeter = Global.level.HUD.dramaMeter
	
	var halfMeter = dramaMeter.audienceValue / 2
	
	if dramaMeter.audienceValue < halfMeter:
		Global.audio.SetSFX("CrowdBooing")
	elif dramaMeter.audienceValue > halfMeter:
		Global.audio.SetSFX("CrowdApplause")
	
	Global.audio.sfxPlayer.play()

func _restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")
	Global.audio.musicPlayer.play()
	queue_free()

func _back_to_menu() -> void:
	Global.sceneTransition.transition("res://scenes/screens/menu_interface.tscn")
	Global.audio.musicPlayer.play()
	queue_free()

func _on_restart_button_cursor_selected() -> void:
	animationPlayer.play("gameover/restart_pressed")
	_restart_game()

func _on_menu_button_cursor_selected() -> void:
	animationPlayer.play("gameover/menu_pressed")
	_back_to_menu()
