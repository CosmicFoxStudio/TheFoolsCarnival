class_name Trigger extends Area2D

enum eTriggerType { MUSIC, ITEM }

@export var type : eTriggerType = eTriggerType.MUSIC
@export var value : String = ""

func _ready() -> void:
	var parent = get_parent()

	var count = 0
	for child in parent.get_children():
		if child is Trigger:
			count += 1

	print("Number of Trigger instances in the current level: ", count)

func _on_area_entered(__area: PlayerInteraction) -> void:
	if (type == eTriggerType.MUSIC) and (__area is PlayerInteraction):
		Global.audio.SetMusic(value)
