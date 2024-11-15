class_name CharacterState extends Resource

const state_type = preload("res://scripts/characters/state_type_enum.gd").state_type

var done:bool
var type:state_type

func _init(_type:state_type, _done:bool = false):
	done = _done
	type = _type
