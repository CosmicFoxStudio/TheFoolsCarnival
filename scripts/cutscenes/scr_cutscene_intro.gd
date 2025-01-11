extends Scene

@export var cutsceneName : String = "intro_cutscene/cutscene_1"

@onready var cutscenePlayer: AnimationPlayer = $CutscenePlayer
@onready var nextButton: Button = $SideButtons/NextButton
@onready var skipButton: Button = $SideButtons/SkipButton
@onready var dialogueLabel: Label = $DialogueBoxLabel
@onready var cursor: Cursor = $Cursor

func _ready() -> void:
	Global.audio.SetMusic("Intro")
	
	cutscenePlayer.play(cutsceneName)
	nextButton.visible = false
	cursor.visible = false

func _process(_delta: float) -> void:
	if cutscenePlayer.current_animation_position >= cutscenePlayer.current_animation_length:
		# Change scene after the cutscene is done
		Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

func _pause() -> void:
	cutscenePlayer.pause()
	nextButton.visible = true
	cursor.visible = true

func _skip() -> void:
	# Skip the scene
	cutscenePlayer.seek(cutscenePlayer.current_animation_length - 1, true)
	Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

func _on_next_button_cursor_selected() -> void:
	if cutscenePlayer.current_animation_position >= cutscenePlayer.current_animation_length:
		Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

	if not cutscenePlayer.is_playing():
		cutscenePlayer.play()
		nextButton.visible = false
		cursor.visible = false

func _on_skip_button_cursor_selected() -> void:
	_skip()
	cutscenePlayer.play()
