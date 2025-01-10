extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var dramaLevel : String

func PlayReaction(__animName: String) -> void:
	if animationPlayer.has_animation(__animName):
		animationPlayer.play(__animName)
	else:
		print("Animation not found: ", __animName)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
