extends Control

### BEWARE OF CYCLICAL REFERENCES HERE
@export var sceneManager : SceneManager
@export var gameScene : PackedScene
@export var menuScene : PackedScene
@export var selectionSequence : AnimationPlayer

func _ready() -> void:
	selectionSequence.play("gameover/start")

func _on_restart_button_button_up() -> void:
	selectionSequence.play("gameover/restart_pressed")

func _on_menu_button_button_up() -> void:
	selectionSequence.play("gameover/menu_pressed")
