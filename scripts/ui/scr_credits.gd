class_name Credits extends Control

@onready var mainMenuCursor: Cursor = $"../Cursor"

func _on_back_button_cursor_selected() -> void:
	# Activate MainMenu Navigation
	mainMenuCursor.inactive = false
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,self.size.y),.35)
