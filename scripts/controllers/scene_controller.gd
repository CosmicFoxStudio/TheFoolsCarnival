class_name MainScene extends Scene

signal loaded()

@onready var sceneTransition: SceneTransition = $LayerTransition/Transition
@onready var layerControl: CanvasLayer = $LayerControl
@onready var layer2D : Node2D = $Layer2D
var sceneInstance : Node = null

func _ready() -> void:
	# Allows a new seed every run
	randomize()
	
	# Hides the mouse cursor
	# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	Global.mainScene = self

	# Load first scene
	# load_scene("res://scenes/screens/menu_interface.tscn")
	load_scene("res://scenes/screens/levels/lvl_circus_1.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()  # Exit the game

func _process(_delta: float) -> void: pass
	# DEBUG
	# if Input.is_action_just_pressed("switch_scene"): sceneTransition.transition(nextScene, transitionType)

func load_scene(screen_name: String) -> void:
	# print(sceneInstance) # DEBUG
	unload_scene()

	var scene_resource := load(screen_name)
	if scene_resource:
		sceneInstance = scene_resource.instantiate()
		if sceneInstance.is_class("Control"):
			if not sceneInstance.is_inside_tree(): layerControl.add_child(sceneInstance)
		elif sceneInstance.is_class("Node2D"):
			if not sceneInstance.is_inside_tree(): layer2D.add_child(sceneInstance)
	
	# Simulate wait time
	if sceneTransition.transitionType == sceneTransition.TransitionType.FADE:
		await get_tree().create_timer(1.0).timeout
	else:
		await get_tree().create_timer(0.1).timeout
	
	loaded.emit()

func unload_scene() -> void:
	if is_instance_valid(sceneInstance):
		sceneInstance.queue_free()
	sceneInstance = null
