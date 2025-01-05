@tool
class_name HitEffect extends Node2D

@export var hitEffectResource : HitEffectResource

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var animation_player: AnimationPlayer

var time : float = 0

func _set_hitEffectRes(hitEffectRes : HitEffectResource) -> void:
	self.hitEffectResource = hitEffectRes
	sprite_2d.texture = hitEffectResource.hit_sprite_sheet
	

func _ready() -> void:
	sprite_2d.texture = hitEffectResource.hit_sprite_sheet
	animation_player.play("effects_anims/hit_effect")
	

func _process(delta: float) -> void:
	
	if not hitEffectResource:
		return
		
	if Engine.is_editor_hint():
		sprite_2d.texture = hitEffectResource.hit_sprite_sheet
	
	
	# Changes the Color based on the Position of the Gradient
	sprite_2d.self_modulate = hitEffectResource.gradient.sample(animation_player.current_animation_position / animation_player.current_animation_length)
	
