class_name Scene extends Node

# @export_file (".tscn") var nextScene: String

@export var transitionType : SceneTransition.TransitionType = Global.sceneTransition.TransitionType.FADE
@export var emitsLoadedSignal : bool = true

func activate() -> void: pass

func _process(_delta: float) -> void: pass
	# DEBUG
	# if Input.is_action_just_pressed("switch_scene"): Global.sceneTransition.transition(nextScene, transitionType)
