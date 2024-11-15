class_name Scene extends Node

@export_file (".tscn") var next_scene: String

@export var transition_type : SceneTransition.TransitionType = Global.scene_transition.TransitionType.FADE
@export var emits_loaded_signal : bool = true

func activate() -> void:
	pass

func _process(_delta: float) -> void:
	# DEBUG
	if Input.is_action_just_pressed("switch_scene"):
		Global.scene_transition.transition(next_scene, transition_type)
