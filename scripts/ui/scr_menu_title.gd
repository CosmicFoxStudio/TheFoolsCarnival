extends Scene

@onready var animationPlayer: AnimationPlayer = $MenuAnimationPlayer
@onready var gridContainer: GridContainer = $Buttons

var selected_index: int = 0

func _ready() -> void:
	Global.audio.SetMusic("Title")
	Global.audio.ResumeMusic()

	animationPlayer.play("MenuOperations/curtain_sequence")

# func _on_start_button_focus_entered() -> void:
	# Global.audio.SetSFX("CursorMenuEnter")

# func _on_quit_button_focus_entered() -> void:
	# Global.audio.SetSFX("CursorMenuBack")

func _on_start_button_cursor_selected() -> void:
	animationPlayer.play("MenuOperations/start_game")
	await animationPlayer.animation_finished
	Global.sceneTransition.transition("res://scenes/screens/game_intro.tscn")

func _on_quit_button_cursor_selected() -> void:
	get_tree().quit()
