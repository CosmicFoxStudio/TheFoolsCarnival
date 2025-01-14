extends Scene

@onready var animationPlayer: AnimationPlayer = $MenuAnimationPlayer
@onready var gridContainer: GridContainer = $Buttons
@onready var credits: Credits = $Credits
@onready var credits_box: TextureRect = $Credits/CreditsBox
@onready var mainMenuCursor: Cursor = $Cursor

var selected_index: int = 0

func _ready() -> void:
	Global.audio.SetMusic("Title")
	Global.audio.ResumeMusic()
	animationPlayer.play("MenuOperations/curtain_sequence")

# func _on_start_button_focus_entered() -> void: # Global.audio.SetSFX("CursorMenuEnter")

# func _on_quit_button_focus_entered() -> void: # Global.audio.SetSFX("CursorMenuBack")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_reject") && credits.position <= Vector2.ZERO:
		var tween = get_tree().create_tween()
		tween.tween_property(credits,"position",Vector2(0,credits.size.y),.35)

func _on_start_button_cursor_selected() -> void:
	animationPlayer.play("MenuOperations/start_game")
	await animationPlayer.animation_finished
	Global.sceneTransition.transition("res://scenes/screens/game_intro.tscn")

func _on_quit_button_cursor_selected() -> void:
	get_tree().quit()

func _on_credits_button_cursor_selected() -> void:
	credits.mainMenuCursor.inactive = true
	mainMenuCursor.inactive = true
	var tween = get_tree().create_tween()
	tween.tween_property(credits,"position",Vector2(0,0),.35)
	tween.tween_callback(turn_backbtn_on).set_delay(.35)
	
func turn_backbtn_on():
	credits.mainMenuCursor.inactive = false
