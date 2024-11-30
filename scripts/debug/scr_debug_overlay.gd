class_name DebugOverlay extends Control

@onready var overridableLabel: Label = $VBoxContainer/MarginContainer/OverridableLabel

func UpdateDebugInfo(__debugInfo: String) -> String:
	overridableLabel.text = __debugInfo
	return __debugInfo
