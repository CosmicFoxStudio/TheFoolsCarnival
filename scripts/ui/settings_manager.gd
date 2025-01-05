extends Control

@export var music_volume : ScrollBar
@export var sfx_volume : ScrollBar


func _process(delta: float) -> void:
	Global.audioManager.music_volume = music_volume.value
	Global.audioManager.sfx_volume = sfx_volume.value
