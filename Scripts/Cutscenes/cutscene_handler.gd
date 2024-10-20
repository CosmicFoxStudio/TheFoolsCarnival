extends Node2D

@export var cutscene_player: AnimationPlayer
@export var skipButton : Button

func _ready() -> void:
	cutscene_player.play("intro_cutscene/cutscene_1") # Starts the Cutscene
	
func _skip() -> void:
	# Skip scene
	cutscene_player.seek(cutscene_player.current_animation_length,true);


func _on_skip_button_pressed() -> void:
	_skip()
