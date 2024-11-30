extends Node

@export var bg_music_stage : AudioStreamPlayer

var current_stage : String

func _ready() -> void:
	current_stage = AudioGlobal.current_stage
	
	
func _process(delta: float) -> void:
	if(current_stage != AudioGlobal.current_stage):
		current_stage = AudioGlobal.current_stage
		update_music_for_scene()
		
func update_music_for_scene():
	var current_stage_music = str(current_stage + "Music") # Gets the Name of the Clip, each one MUST present the naming convention "Music" at the end
	bg_music_stage["parameters/switch_to_clip"] = current_stage
	
