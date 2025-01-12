class_name Settings extends Control

@onready var settingsButton: Button = $OpenSettingsButton
@onready var vBoxContainer: VBoxContainer = $SettingsBox/VBoxContainer

@onready var _musicVolume: HScrollBar = $"SettingsBox/VBoxContainer/Music/Music (in dB)"
@onready var _sfxVolume: HScrollBar = $"SettingsBox/VBoxContainer/Sounds/SFX (in dB)"

@onready var _controlsBox: TextureRect = $ControlsBox
@onready var _settings_box: TextureRect = $SettingsBox
@onready var _cursor: Cursor = $Cursor

var paused: bool = false
var active: bool = false
var music_selected: bool = false
var sfx_selected: bool = false

func _ready() -> void:
	Global.settings = self

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_escape"):
		ToggleSettingsMenu()

	if paused:
		if Input.is_action_just_pressed("ui_home"):
			ToggleControlsPanel()

		if music_selected: # Control music volume sliders
			if Input.is_action_just_pressed("ui_left"):
				_musicVolume.value -= 5
			elif Input.is_action_just_pressed("ui_right"):
				_musicVolume.value += 5

		if sfx_selected: # Control SFX volume sliders
			if Input.is_action_just_pressed("ui_left"):
				_sfxVolume.value -= 5
			elif Input.is_action_just_pressed("ui_right"):
				_sfxVolume.value += 5

func _process(_delta: float) -> void:
	if active:
		Global.audio.musicVolume = _musicVolume.value
		Global.audio.sfxVolume = _sfxVolume.value

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
	_controlsBox.visible = !_controlsBox.visible
	_settings_box.visible = !_settings_box.visible
	_cursor.visible = !_cursor.visible

func _on_settings_button_toggled(toggled_on: bool) -> void:
	_controlsBox.visible = toggled_on

func _on_settings_button_cursor_selected() -> void:
	_controlsBox.visible = true

func _on_music_cursor_selected() -> void:
	Global.debug.DebugPrint("Music Volume selected")
	music_selected = true
	_musicVolume.self_modulate = Color(1, 1, 0)

func _on_music_cursor_deselected() -> void:
	Global.debug.DebugPrint("Music Volume deselected")
	music_selected = false
	_musicVolume.self_modulate = Color(1, 1, 1)

func _on_sounds_cursor_selected() -> void:
	Global.debug.DebugPrint("SFX Volume selected")
	sfx_selected = true
	_sfxVolume.self_modulate = Color(1, 1, 0)

func _on_sounds_cursor_deselected() -> void:
	Global.debug.DebugPrint("SFX Volume deselected")
	sfx_selected = false
	_sfxVolume.self_modulate = Color(1, 1, 1)
