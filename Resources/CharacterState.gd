extends Resource
class_name CharacterState

const state_type = preload("res://Scripts/state_type_enum.gd").state_type

var done:bool
var type:state_type

func _init(_type:state_type, _done:bool = false):
	done = _done
	type = _type
