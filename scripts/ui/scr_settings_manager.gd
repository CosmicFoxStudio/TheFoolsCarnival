extends Control

@export var settingsButton : Button 
@export var vBoxContainer : BoxContainer

@onready var _musicVolume: HScrollBar = $"VBoxContainer/Music (in dB)"
@onready var _sfxVolume: HScrollBar = $"VBoxContainer/SFX (in dB)"
@onready var _controlsBox: TextureRect = $ControlsBox

var paused := false
var music_selected : bool
var sfx_selected : bool 

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_enter"):
		# Pauses the Game
		paused = !paused

	get_tree().paused = paused
	vBoxContainer.visible = paused
	
	if paused:
		var tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(settingsButton,"position",Vector2(420,-72),.5).set_ease(Tween.EASE_IN)
		tween.play()
		
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	else:
		var tween = get_tree().create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(settingsButton,"position",Vector2(420,-115),.5).set_ease(Tween.EASE_IN)
		tween.play()
		
		#Engine.time_scale = 1
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		
	if Input.is_action_just_pressed("ui_home"):
		_controlsBox.visible = false


func _process(_delta: float) -> void:
	Global.audio.musicVolume = _musicVolume.value
	Global.audio.sfxVolume = _sfxVolume.value
	
	if music_selected:
		if Input.is_action_just_pressed("ui_left"):
			_musicVolume.value -= 5
		
		elif Input.is_action_just_pressed("ui_right"):
			_musicVolume.value += 5
	
	if sfx_selected:
		if Input.is_action_just_pressed("ui_left"):
			_sfxVolume.value -= 5
	
		if Input.is_action_just_pressed("ui_right"):
			_sfxVolume.value += 5

func _on_settings_button_toggled(toggled_on: bool) -> void:
	_controlsBox.visible = toggled_on


func _on_settings_button_cursor_selected() -> void:
	_controlsBox.visible = true


func _on_music_cursor_selected() -> void:
	Global.debug.DebugPrint("Music Volume selected")
	music_selected = true
	_musicVolume.self_modulate = Color(1,1,0)


func _on_sfx_cursor_selected() -> void:
	Global.debug.DebugPrint("SFX Volume selected")
	sfx_selected = true
	_sfxVolume.self_modulate = Color(1,1,0)	

func _on_music_cursor_deselected() -> void:
	Global.debug.DebugPrint("Music Volume deselected")
	music_selected = false
	_musicVolume.self_modulate = Color(1,1,1)


func _on_sfx_cursor_deselected() -> void:
	Global.debug.DebugPrint("SFX Volume deselected")
	sfx_selected = false
	_sfxVolume.self_modulate = Color(1,1,1)
