@tool
extends Node

@export var hitEffectResource : HitEffectResource

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var animation_player: AnimationPlayer



var time : float = 0

func _ready() -> void:
	sprite_2d.texture = hitEffectResource.hit_sprite_sheet
	

func _process(delta: float) -> void:
	
	if not hitEffectResource:
		return
		
	if Engine.is_editor_hint():
		sprite_2d.texture = hitEffectResource.hit_sprite_sheet
	
	
	# Changes the Color based on the Position of the Gradient
	sprite_2d.self_modulate = hitEffectResource.gradient.sample(animation_player.current_animation_position)
	
