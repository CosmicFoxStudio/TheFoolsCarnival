extends Control

@onready var musicVolume: HScrollBar = $"VBoxContainer/Music (in dB)"
@onready var sfxVolume: HScrollBar = $"VBoxContainer/SFX (in dB)"

func _process(_delta: float) -> void:
	Global.audio.musicVolume = musicVolume.value
	Global.audio.sfxVolume = sfxVolume.value
