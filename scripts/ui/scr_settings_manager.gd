extends Control

@export var settingsButton : Button 

@onready var _musicVolume: HScrollBar = $"VBoxContainer/Music (in dB)"
@onready var _sfxVolume: HScrollBar = $"VBoxContainer/SFX (in dB)"
@onready var _controlsBox: TextureRect = $ControlsBox

var paused := false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_enter"):
		# Pauses the Game
		paused = !paused

	get_tree().paused = paused
	if paused:
		var tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(settingsButton,"position",Vector2(420,-72),.5).set_ease(Tween.EASE_IN)
		tween.play()
		
		#Engine.time_scale = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	else:
		var tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(settingsButton,"position",Vector2(420,-115),.5).set_ease(Tween.EASE_IN)
		tween.play()
		
		#Engine.time_scale = 1

func _process(_delta: float) -> void:
	Global.audio.musicVolume = _musicVolume.value
	Global.audio.sfxVolume = _sfxVolume.value

func _on_settings_button_toggled(toggled_on: bool) -> void:
	_controlsBox.visible = toggled_on
