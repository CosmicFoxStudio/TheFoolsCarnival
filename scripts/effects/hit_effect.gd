@tool
extends Node

@export var hitEffectResource : HitEffectResource
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var time : float = 0

func _init() -> void:
	sprite_2d.texture = hitEffectResource.hit_sprite_sheet

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	
	if not hitEffectResource:
		return
		
	time += delta
	
	sprite_2d.self_modulate = hitEffectResource.gradient.sample(time * 5)
	
	if(time > 1):
		time = 0
		
	time = clamp(time,0,1)
	
