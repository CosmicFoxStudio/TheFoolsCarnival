extends Scene

@export var cutsceneName : String = "intro_cutscene/cutscene_1"

@onready var cutscene_player: AnimationPlayer = $CutscenePlayer
@onready var nextButton: Button = $SideButtons/NextButton
@onready var skipButton: Button = $SideButtons/SkipButton
@onready var dialogueLabel: Label = $DialogueBoxLabel

var buttons: Array[Button] = []
var selected_button_index: int = 0

func _ready() -> void:
	cutscene_player.play(cutsceneName)
	nextButton.visible = false

	buttons = [$SideButtons/NextButton, $SideButtons/SkipButton]

	# Highlight the first button by default
	_highlight_button(selected_button_index)

func _process(_delta: float) -> void:
	if cutscene_player.current_animation_position >= cutscene_player.current_animation_length:
		# Change scene after the cutscene is done
		Global.scene_transition.transition("res://scenes/screens/main.tscn")

func _pause() -> void:
	cutscene_player.pause()
	nextButton.visible = true

func _skip() -> void:
	# Skip the scene
	cutscene_player.seek(cutscene_player.current_animation_length - 1, true)
	Global.scene_transition.transition("res://scenes/screens/main.tscn")

func _on_skip_button_pressed() -> void:
	_highlight_button(selected_button_index)
	_skip()
	cutscene_player.play()

func _on_next_button_pressed() -> void:
	_highlight_button(selected_button_index)
	if cutscene_player.current_animation_position >= cutscene_player.current_animation_length:
		Global.scene_transition.transition("res://scenes/screens/main.tscn")

	if not cutscene_player.is_playing():
		cutscene_player.play()
		nextButton.visible = false

func _input(event: InputEvent) -> void:
	if Global.scene_transition.in_transition: return

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
