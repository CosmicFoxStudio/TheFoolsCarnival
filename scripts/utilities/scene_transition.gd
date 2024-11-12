extends Node

class_name SceneTransition

signal transition_in()
signal transition_out()

@onready var overlay_color_rect: ColorRect = $OverlayColorRect
@onready var screenshot_texture: TextureRect = $ScreenshotTexture
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Global.scene_transition = self
	
func transition(scenePath: String) -> void:
	#Place animation dither_in dither_out here
	pass
	
