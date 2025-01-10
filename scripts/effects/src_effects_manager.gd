class_name EffectManager extends Node

@export var hitEffectResources : Array[HitEffectResource] = []

var hitEffectPrefab := preload("res://scenes/prefab/effects/hit_effect.tscn")

func _enter_tree() -> void:
	Global.effects = self

func spawn_effect(hitEffectRes : HitEffectResource, spawnPos : Vector2) -> HitEffect:
	var effect = hitEffectPrefab.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as HitEffect
	
	self.add_child(effect)
	
	# effect.name = "Instance_" + hitEffectRes.resource_name
	effect._set_hitEffectRes(hitEffectRes)
	effect.position = spawnPos
	return effect

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton: 
		spawn_effect(hitEffectResources.pick_random(), event.position)
	
