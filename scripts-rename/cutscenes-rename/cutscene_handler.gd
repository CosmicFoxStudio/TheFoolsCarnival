extends Node2D

@export var cutscene_player: AnimationPlayer
@export var nextButton : Button
@export var skipButton : Button
@export var dialogueLabel : Label
@export var cutsceneName : String
@export var sceneManager : SceneManager

func _ready() -> void:
	cutscene_player.play(cutsceneName) # Starts the Cutscene
	nextButton.visible = false

func _process(_delta: float) -> void:
	if(cutscene_player.current_animation_position >= cutscene_player.current_animation_length):
		get_tree().change_scene_to_file("res://scenes-rename/main.tscn")

func _pause() -> void:
	cutscene_player.pause()
	nextButton.visible = true


func _skip() -> void:
	# Skip scene
	cutscene_player.seek(cutscene_player.current_animation_length - 1,true);

	# get_tree().change_scene_to_file("res://scenes-rename/main.tscn")
	sceneManager.load_scene("res://scenes-rename/main.tscn")

func _on_skip_button_pressed() -> void:
	_skip()
	cutscene_player.play()

func _on_next_button_pressed() -> void:
	if(cutscene_player.current_animation_position >= cutscene_player.current_animation_length):
		sceneManager.load_scene("res://scenes-rename/main.tscn")
		return

	if(not cutscene_player.is_playing()):
		cutscene_player.play()
		nextButton.visible = false
