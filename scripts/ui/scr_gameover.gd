extends Scene

@onready var animation_player : AnimationPlayer = $SelectionSequence
# @onready var gameover_sfxs: AudioStreamPlayer = $GameOverSFXs

var dramaMeter : DramaMeter

func _ready() -> void:
	animation_player.play("gameover/start")
	Global.audio.musicPlayer.stop()
	
	dramaMeter = Global.level._HUD.dramaMeter
	
	var halfMeter = dramaMeter.audienceValue / 2
	
	if dramaMeter.audienceValue < halfMeter:
		Global.audio.SetSFX("CrowdBooing")
	elif dramaMeter.audienceValue > halfMeter:
		Global.audio.SetSFX("CrowdApplause")
	
	Global.audio.sfxPlayer.play()
	
	 

func _restart_game() -> void:
	Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")
	Global.audio.musicPlayer.play()
	queue_free()

func _back_to_menu() -> void:
	Global.sceneTransition.transition("res://scenes/screens/menu_interface.tscn")
	Global.audio.musicPlayer.play()
	queue_free()

func _on_restart_button_cursor_selected() -> void:
	animation_player.play("gameover/restart_pressed")
	_restart_game()

func _on_menu_button_cursor_selected() -> void:
	animation_player.play("gameover/menu_pressed")
	_back_to_menu()
