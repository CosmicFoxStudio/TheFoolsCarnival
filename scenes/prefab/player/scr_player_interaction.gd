extends Area2D

@onready var player : Player = get_parent()

func _on_area_entered(area: Area2D) -> void:
	if area is CameraLimiter:
		Global.level.camera.limitManager.SetLimiter(area)
