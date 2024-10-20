extends Control

@export var animPlayer : AnimationPlayer
@export var gameScene : PackedScene

func _ready() -> void:
	animPlayer.play("MenuOperations/curtain_sequence")
	print(animPlayer.current_animation)
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(gameScene.resource_path)
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()
