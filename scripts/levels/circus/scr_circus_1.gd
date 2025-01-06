extends LevelController

# Unique script for LevelCircus1

func _ready() -> void:
	super()
	Global.debug.DebugPrint(get_name() + " Loaded.")
