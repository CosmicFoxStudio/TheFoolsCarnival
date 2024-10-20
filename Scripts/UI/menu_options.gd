extends Control

@export var animPlayer : AnimationPlayer
@export var gameScene : PackedScene

func _ready() -> void:
	animPlayer.play("MenuOperations/curtain_sequence")
	
func _on_start_button_pressed() -> void:
	animPlayer.play("MenuOperations/start_game")
	await animPlayer.current_animation_position >= animPlayer.current_animation_length
	get_tree().change_scene_to_file(gameScene.resource_path)
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()
