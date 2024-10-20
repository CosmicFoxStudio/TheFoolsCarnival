extends Node2D

@export var cutscene_player: AnimationPlayer
@export var skipButton : Button
@export var dialogueLabel : Label

@export var cutsceneName : String

func _ready() -> void:
	cutscene_player.play(cutsceneName) # Starts the Cutscene
	skipButton.visible = false

func _process(delta: float) -> void:
	if(Input.is_anything_pressed() and not cutscene_player.is_playing()):
		cutscene_player.play()
		
	if(Input.is_anything_pressed()):
		skipButton.visible = true
	
func _pause() -> void:
	cutscene_player.pause()
	
func _skip() -> void:
	# Skip scene
	cutscene_player.seek(cutscene_player.current_animation_length,true);


func _on_skip_button_pressed() -> void:
	_skip()
