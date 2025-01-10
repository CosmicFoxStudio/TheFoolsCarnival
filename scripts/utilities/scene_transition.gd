class_name SceneTransition extends Node

signal sTransitionedIn()
signal sTransitionedOut()

enum TransitionType { FADE, PIXELATE, DITHER }

var currentScene : Node : set=SetCurrentScene
var inTransition : bool = false
var transitionType : TransitionType = TransitionType.FADE

var transitionData = {
	TransitionType.FADE: { "in": "anim_transitions/fade_in", "out": "anim_transitions/fade_out" },
	TransitionType.PIXELATE: { "in": "anim_transitions/pixelate_in", "out": "anim_transitions/pixelate_out" },
	TransitionType.DITHER: { "in": "anim_transitions/dither_in", "out": "anim_transitions/dither_out" }
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
# @onready var overlay_color_rect: ColorRect = $OverlayColorRect
@onready var margin_container : MarginContainer = $MarginContainer
@onready var screenshot_texture_rect : TextureRect = $ScreenshotTexture

func _ready() -> void:
	Global.sceneTransition = self
	currentScene = get_tree().current_scene

# Runs every new scene
func SetCurrentScene(value: Node) -> void:
	if currentScene == null:
		currentScene = value
		return
	
	currentScene = value
	var root: Window = get_tree().get_root()
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(value)

# General transition function (in and out) based on the current transition type
func transition(scene: String, type: TransitionType = transitionType) -> void:
	if inTransition: return  # Return if already in transition

	inTransition = true

	transitionType = type  # Set the transition type based on the argument

	transition_in()
	await sTransitionedIn

	# =======================================================
	#  ============== MANUALLY LOADING SCENES ===============
	# Instead of using Godot's built-in functions
	# =======================================================
	
	# Load and instantiate the new scene
	Global.mainScene.load_scene(scene)
	var newScene = Global.mainScene.sceneInstance
	# print("New scene: ", newScene) # Debugging
	
	if newScene.emitsLoadedSignal:
		await Global.mainScene.loaded

	transition_out()
	await sTransitionedOut

	# (TO-DO) Activate the new scene
	newScene.activate()

	inTransition = false

# Handle transition in
func transition_in() -> void:
	var animation = transitionData[transitionType]["in"]
	if transitionType == TransitionType.PIXELATE:
		transition_pixelate_in(animation)
	else: # Default to Fade Anim
		transition_fade_in(animation)

# Handle transition out
func transition_out() -> void:
	var animation = transitionData[transitionType]["out"]
	if transitionType == TransitionType.PIXELATE:
		transition_pixelate_out(animation)
	else: # Default to Fade Anim
		transition_fade_out(animation)

	# =======================================================
	#  ================= TRANSITION TYPES ===================
	# =======================================================

# Place animation dither_in dither_out here

# Pixelate in transition
func transition_pixelate_in(animation : String) -> void:
	# print("Playing Pixelate In animation: ", animation)  # Debugging
	screenshot_texture_rect.take_screenshot()
	screenshot_texture_rect.visible = true
	animation_player.play(animation)

# Pixelate out transition
func transition_pixelate_out(animation : String) -> void:
	# print("Playing Pixelate Out animation: ", animation)  # Debugging
	screenshot_texture_rect.take_screenshot()
	screenshot_texture_rect.visible = true
	animation_player.play(animation)

# Fade in transition
func transition_fade_in(animation : String) -> void:
	# print("Fading in...")
	animation_player.play(animation)

# Fade out transition
func transition_fade_out(animation : String) -> void:
	# print("Fading out...")
	show_loading_label()
	animation_player.play(animation)

# Show a loading label during fade transitions
func show_loading_label() -> void:
	if transitionType == TransitionType.FADE:
		create_tween().tween_property(margin_container, "scale", Vector2.ZERO, 0.3)

# Emit signals when animation finishes
func _on_animation_player_animation_finished(__animName: StringName) -> void:
	# print("Animation Finished: ", anim_name)  # Debugging
	if __animName == transitionData[transitionType]["in"]:
		if transitionType == TransitionType.FADE:
			animation_player.play("pulse_text")
		sTransitionedIn.emit()
	elif __animName == transitionData[transitionType]["out"]:
		sTransitionedOut.emit()
		screenshot_texture_rect.visible = false
