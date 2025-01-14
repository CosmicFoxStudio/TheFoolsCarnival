extends Scene

@onready var animationPlayer: AnimationPlayer = $MenuAnimationPlayer
@onready var gridContainer: GridContainer = $Buttons
@onready var credits_box: TextureRect = $CreditsBox

var selected_index: int = 0

func _ready() -> void:
	Global.audio.SetMusic("Title")
	Global.audio.ResumeMusic()

	animationPlayer.play("MenuOperations/curtain_sequence")

# func _on_start_button_focus_entered() -> void:
	# Global.audio.SetSFX("CursorMenuEnter")

# func _on_quit_button_focus_entered() -> void:
	# Global.audio.SetSFX("CursorMenuBack")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_escape") && credits_box.position <= Vector2.ZERO:
		var tween = get_tree().create_tween()
		tween.tween_property(credits_box,"position",Vector2(0,credits_box.size.y),.35)
	
func _on_start_button_cursor_selected() -> void:
	animationPlayer.play("MenuOperations/start_game")
	await animationPlayer.animation_finished
	Global.sceneTransition.transition("res://scenes/screens/game_intro.tscn")

func _on_quit_button_cursor_selected() -> void:
	get_tree().quit()


func _on_credits_button_cursor_selected() -> void:
	credits_box.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(credits_box,"position",Vector2(0,0),.35)


func _on_credits_button_cursor_deselected() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(credits_box,"position",Vector2(0,credits_box.size.y),.35)
	
	
