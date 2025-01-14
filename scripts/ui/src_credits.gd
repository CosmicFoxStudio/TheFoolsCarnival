extends Control

@onready var credits_box: TextureRect = $"."

func _on_close_button_pressed() -> void:
	var twen = get_tree().create_tween()
	twen.tween_property(credits_box,"position",Vector2(0,size.y),.35)
