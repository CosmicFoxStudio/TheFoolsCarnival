class_name Cursor extends Control

@export var isSettings : bool = false
@export var menuParentPath : NodePath
@export var cursorOffset : Vector2

@onready var menuParent := get_node(menuParentPath)
@onready var handTexture: TextureRect = $TextureRect

var inactive : bool = false

var cursorIndex : int = 0
var lastItem : Control

func _process(_delta: float) -> void:
	# Check if other instance deactivated this instance
	if inactive: return 
	
	# Check if settings are active 
	# To decide whether to disable the current menu navigation
	if Global.settings.active:
		if not isSettings: 
			# handTexture.visible = false
			return
	# else: handTexture.visible = true
		
	var input := Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		input.y += 1
	if Input.is_action_just_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		input.x += 1
		
	if menuParent is VBoxContainer:
		set_cursor_from_index(cursorIndex + int(input.y))
	elif menuParent is HBoxContainer:
		set_cursor_from_index(cursorIndex + int(input.x))
	elif menuParent is GridContainer:
		set_cursor_from_index(cursorIndex + int(input.x) + int(input.y) * menuParent.columns)
		
	if Input.is_action_just_pressed("ui_confirm"):
		var currentMenuItem := GetMenuItemAtIndex(cursorIndex)
		
		if(currentMenuItem != null):
			if lastItem != null and lastItem != currentMenuItem:
				if lastItem.has_method("cursor_deselect"):
					lastItem.cursor_deselect()
					
			lastItem = currentMenuItem
			if currentMenuItem.has_method("cursor_select"):
				currentMenuItem.cursor_select()

func GetMenuItemAtIndex(index : int) -> Control:
	if menuParent == null:
		return null
		
	if index >= menuParent.get_child_count() or index < 0:
		return null
		
	return menuParent.get_child(index) as Control
	
func set_cursor_from_index(index : int) -> void:
	var menuItem := GetMenuItemAtIndex(index)
	
	if menuItem == null: return
	
	var pos = menuItem.global_position
	var itemSize = menuItem.size
	
	global_position = Vector2(pos.x, pos.y + itemSize.y / 2.0) - cursorOffset
	
	cursorIndex = index
