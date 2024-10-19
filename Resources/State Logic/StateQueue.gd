extends Resource
class_name StateQueue

const state_type = preload("res://Scripts/state_type_enum.gd").state_type

var queue: Array[CharacterState]
var max_size: int

func _init(_max_size:int):
	queue = []
	max_size = _max_size

func enqueue(type:state_type):
	if find(type) != -1 or queue.size() == max_size:
		return

	var state = CharacterState.new(type)

	queue.append(state)

func dequeue():
	return queue.pop_front()

func find(type:state_type):
	var index = -1

	for i in range(queue.size()):
		var character_state = queue[i]
		if character_state.type == type:
			index = i
			break

	return index

func count_type(type:state_type):
	var count = 0

	for i in range(queue.size()):
		var character_state = queue[i]
		if character_state.type == type:
			count +=1

	return count