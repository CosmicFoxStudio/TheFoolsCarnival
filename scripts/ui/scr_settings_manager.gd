class_name Settings extends Control

@onready var settingsButton: Button = $OpenSettingsButton
@onready var vBoxContainer: VBoxContainer = $SettingsBox/VBoxContainer

@onready var musicVolume: HScrollBar = $"SettingsBox/VBoxContainer/Music/Music (in dB)"
@onready var sfxVolume: HScrollBar = $"SettingsBox/VBoxContainer/Sounds/SFX (in dB)"

@onready var controlsBox: TextureRect = $ControlsBox
@onready var settingsBox: TextureRect = $SettingsBox
@onready var cursor: Cursor = $Cursor

var paused: bool = false
var active: bool = false
var musicSelected: bool = false
var sfxSelected: bool = false

func _ready() -> void:
	Global.settings = self

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_escape"):
		ToggleSettingsMenu()

	if paused:
		if Input.is_action_just_pressed("ui_home"):
			ToggleControlsPanel()

		if musicSelected: # Control music volume sliders
			if Input.is_action_just_pressed("ui_left"):
				musicVolume.value -= 5
			elif Input.is_action_just_pressed("ui_right"):
				musicVolume.value += 5

		if sfxSelected: # Control SFX volume sliders
			if Input.is_action_just_pressed("ui_left"):
				sfxVolume.value -= 5
			elif Input.is_action_just_pressed("ui_right"):
				sfxVolume.value += 5

func _process(_delta: float) -> void:
	if active:
		Global.audio.musicVolume = musicVolume.value
		Global.audio.sfxVolume = sfxVolume.value

func ToggleSettingsMenu() -> void:
	active = !active
	visible = !visible
	paused = !paused

	get_tree().paused = paused
	vBoxContainer.visible = paused

	var tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if paused:
		tween.tween_property(settingsButton, "position", Vector2(420, -72), 0.5).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(settingsButton, "position", Vector2(420, -115), 0.5).set_ease(Tween.EASE_IN)
	tween.play()

func ToggleControlsPanel() -> void:
	controlsBox.visible = !controlsBox.visible
	settingsBox.visible = !settingsBox.visible
	cursor.visible = !cursor.visible

# Signals
func _on_settings_button_toggled(toggled_on: bool) -> void:
	controlsBox.visible = toggled_on

func _on_settings_button_cursor_selected() -> void:
	controlsBox.visible = true

func _on_music_cursor_selected() -> void:
	Global.debug.DebugPrint("Music Volume selected")
	musicSelected = true
	musicVolume.self_modulate = Color(1, 1, 0)

func _on_music_cursor_deselected() -> void:
	Global.debug.DebugPrint("Music Volume deselected")
	musicSelected = false
	musicVolume.self_modulate = Color(1, 1, 1)

func _on_sounds_cursor_selected() -> void:
	Global.debug.DebugPrint("SFX Volume selected")
	sfxSelected = true
	sfxVolume.self_modulate = Color(1, 1, 0)

func _on_sounds_cursor_deselected() -> void:
	Global.debug.DebugPrint("SFX Volume deselected")
	sfxSelected = false
	sfxVolume.self_modulate = Color(1, 1, 1)
