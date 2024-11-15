class_name SceneTransition extends Node

signal transitioned_in()
signal transitioned_out()

enum TransitionType { FADE, PIXELATE, DITHER }

var current_scene : Node : set=set_current_scene
var in_transition : bool = false
var transition_type : TransitionType = TransitionType.FADE

var transition_data = {
	TransitionType.FADE: { "in": "anim_transitions/fade_in", "out": "anim_transitions/fade_out" },
	TransitionType.PIXELATE: { "in": "anim_transitions/pixelate_in", "out": "anim_transitions/pixelate_out" },
	TransitionType.DITHER: { "in": "anim_transitions/dither_in", "out": "anim_transitions/dither_out" }
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
# @onready var overlay_color_rect: ColorRect = $OverlayColorRect
@onready var margin_container : MarginContainer = $MarginContainer
@onready var screenshot_texture_rect : TextureRect = $ScreenshotTexture

func _ready() -> void:
	Global.scene_transition = self
	current_scene = get_tree().current_scene

# Runs every new scene
func set_current_scene(value: Node) -> void:
	if current_scene == null:
		current_scene = value
		return
	
	current_scene = value
	var root: Window = get_tree().get_root()
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(value)

# General transition function (in and out) based on the current transition type
func transition(scene: String, type: TransitionType = transition_type) -> void:
	if in_transition: return  # Return if already in transition

	in_transition = true

	transition_type = type  # Set the transition type based on the argument

	transition_in()
	await transitioned_in

	# =======================================================
	#  ============== MANUALLY LOADING SCENES ===============
	# Instead of using Godot's built-in functions
	# =======================================================
	
	# Load and instantiate the new scene
	Global.main_scene.load_scene(scene)
	var new_scene = Global.main_scene.scene_instance
	# print("New scene: ", new_scene) # Debugging
	
	if new_scene.emits_loaded_signal:
		await Global.main_scene.loaded

	transition_out()
	await transitioned_out

	# Activate the new scene
	new_scene.activate()

	in_transition = false

# Handle transition in
func transition_in() -> void:
	var animation = transition_data[transition_type]["in"]
	if transition_type == TransitionType.PIXELATE:
		transition_pixelate_in(animation)
	else: # Default to Fade Anim
		transition_fade_in(animation)

# Handle transition out
func transition_out() -> void:
	var animation = transition_data[transition_type]["out"]
	if transition_type == TransitionType.PIXELATE:
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
	if transition_type == TransitionType.FADE:
		create_tween().tween_property(margin_container, "scale", Vector2.ZERO, 0.3)

# Emit signals when animation finishes
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	# print("Animation Finished: ", anim_name)  # Debugging
	if anim_name == transition_data[transition_type]["in"]:
		if transition_type == TransitionType.FADE:
			animation_player.play("pulse_text")
		transitioned_in.emit()
	elif anim_name == transition_data[transition_type]["out"]:
		transitioned_out.emit()
		screenshot_texture_rect.visible = false
