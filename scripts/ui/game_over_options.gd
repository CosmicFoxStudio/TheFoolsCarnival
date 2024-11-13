extends Scene

@onready var animation_player : AnimationPlayer = $SelectionSequence

func _ready() -> void:
	animation_player.play("gameover/start")

func _on_restart_button_button_up() -> void:
	animation_player.play("gameover/restart_pressed")

func _on_menu_button_button_up() -> void:
	animation_player.play("gameover/menu_pressed")
