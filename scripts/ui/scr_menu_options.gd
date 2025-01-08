extends Scene

@onready var animation_player: AnimationPlayer = $MenuAnimationPlayer
@onready var menu_grid_container: GridContainer = $Buttons
@onready var menu_items: Array[Button] = []

var selected_index: int = 0

func _ready() -> void:
	# Add buttons to array
	for child in menu_grid_container.get_children():
		if child is Button:
			menu_items.append(child)

	animation_player.play("MenuOperations/curtain_sequence")
	_update_selection()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		selected_index += 1
		if selected_index >= menu_items.size():
			selected_index = 0
		_update_selection()
	
	elif event.is_action_pressed("ui_up"):
		selected_index -= 1
		if selected_index < 0:
			selected_index = menu_items.size() - 1
		_update_selection()
	
	elif event.is_action_pressed("ui_accept"):
		_on_menu_item_selected()

# Update the appearance of the selected menu item
func _update_selection() -> void:
	for i in range(menu_items.size()):
		if i == selected_index:
			menu_items[i].add_theme_color_override("font_color", Color(1, 1, 0))
		else:
			menu_items[i].add_theme_color_override("font_color", Color(1, 1, 1))
	
	Global.audio.PlaySFX(0)

func _on_menu_item_selected() -> void:
	match selected_index:
		0: # Start
			_on_start_button_pressed()
		1: # Quit
			_on_quit_button_pressed()

func _on_start_button_pressed() -> void:
	animation_player.play("MenuOperations/start_game")
	await animation_player.animation_finished
	Global.sceneTransition.transition("res://scenes/screens/game_intro.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_focus_entered() -> void:
	Global.audio.PlaySFX(0)


func _on_quit_button_focus_entered() -> void:
	Global.audio.PlaySFX(1)
