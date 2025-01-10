extends Control

signal cursor_selected()
signal cursor_deselected()

func cursor_select() -> void:
	cursor_selected.emit()

func cursor_deselect() -> void:
	cursor_deselected.emit()
