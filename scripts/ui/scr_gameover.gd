extends Scene

@onready var animation_player : AnimationPlayer = $SelectionSequence

func _ready() -> void:
	animation_player.play("gameover/start")

func _on_restart_button_button_up() -> void:
	animation_player.play("gameover/restart_pressed")
	_restart_game()

func _on_menu_button_button_up() -> void:
	animation_player.play("gameover/menu_pressed")
	_back_to_menu()

func _restart_game() -> void:
	Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

func _back_to_menu() -> void:
	Global.sceneTransition.transition("res://scenes/screens/menu_interface.tscn")
