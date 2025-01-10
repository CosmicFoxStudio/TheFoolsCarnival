extends Scene

@export var cutsceneName : String = "intro_cutscene/cutscene_1"

@onready var cutscenePlayer: AnimationPlayer = $CutscenePlayer
@onready var nextButton: Button = $SideButtons/NextButton
@onready var skipButton: Button = $SideButtons/SkipButton
@onready var dialogueLabel: Label = $DialogueBoxLabel

var buttons: Array[Button] = []
var selected_button_index: int = 0

func _ready() -> void:
	Global.audio.SetMusic("Intro")
	
	cutscenePlayer.play(cutsceneName)
	nextButton.visible = false

	buttons = [$SideButtons/NextButton, $SideButtons/SkipButton]

	# Highlight the first button by default
	_highlight_button(selected_button_index)

func _process(_delta: float) -> void:
	if cutscenePlayer.current_animation_position >= cutscenePlayer.current_animation_length:
		# Change scene after the cutscene is done
		Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

func _pause() -> void:
	cutscenePlayer.pause()
	nextButton.visible = true

func _skip() -> void:
	# Skip the scene
	cutscenePlayer.seek(cutscenePlayer.current_animation_length - 1, true)
	Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

func _on_skip_button_pressed() -> void:
	_highlight_button(selected_button_index)
	_skip()
	cutscenePlayer.play()

func _on_next_button_pressed() -> void:
	_highlight_button(selected_button_index)
	if cutscenePlayer.current_animation_position >= cutscenePlayer.current_animation_length:
		Global.sceneTransition.transition("res://scenes/screens/levels/lvl_circus_1.tscn")

	if not cutscenePlayer.is_playing():
		cutscenePlayer.play()
		nextButton.visible = false

func _input(event: InputEvent) -> void:
	if Global.sceneTransition.inTransition: return

	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_down"):
			# Wrap around
			selected_button_index = (selected_button_index + 1) % buttons.size()
			_highlight_button(selected_button_index)
		elif Input.is_action_just_pressed("ui_up"):
			# Wrap around
			selected_button_index = (selected_button_index - 1 + buttons.size()) % buttons.size()
			_highlight_button(selected_button_index)

		if Input.is_action_just_pressed("ui_accept"):
			_activate_button(selected_button_index)

		elif Input.is_action_just_pressed("ui_cancel"):
			_on_skip_button_pressed()

func _highlight_button(index: int) -> void:
	for button in buttons:
		# Reset color to normal (white)
		button.modulate = Color(1, 1, 1) 

	# Yellow color for highlight
	buttons[index].modulate = Color(1, 1, 0)

func _activate_button(index: int) -> void:
	if index == 0:
		_on_next_button_pressed()
	elif index == 1:
		_on_skip_button_pressed()
