class_name GlobalDebug extends Control

const MAX_LABELS = 20

var debugTheme : Theme = preload("res://themes/theme_debug.tres")
var labelSlots : Array[Label] = []

@onready var mousePositionLabel : Label = $MousePositionLabel
@onready var vBoxContainer: VBoxContainer = $VBoxContainer

func DebugPrint(message: String) -> void:
	print("[", str(self.name), "] ", message)
	
func AddDebugVariable(__message: String) -> void:
	var newLabel = Label.new()
	newLabel.text = __message

	if debugTheme != null: newLabel.theme = debugTheme

	if vBoxContainer.get_child_count() >= MAX_LABELS:
		vBoxContainer.get_child(0).queue_free()

	vBoxContainer.add_child(newLabel)

func UpdateDebugVariable(slot_index: int, message: String) -> void:
	if slot_index >= 0 and slot_index < MAX_LABELS:
		labelSlots[slot_index].text = message

		if message == "":
			labelSlots[slot_index].hide()
		else:
			labelSlots[slot_index].show()

# Clear a debug variable in a specific slot
func ClearDebugVariable(slot_index: int) -> void:
	if slot_index >= 0 and slot_index < MAX_LABELS:
		labelSlots[slot_index].text = ""
		labelSlots[slot_index].hide()

### MAIN LOOP
func _ready() -> void:
	Global.debug = self
	
	# Pre-create label slots
	for i in range(MAX_LABELS):
		var newLabel = Label.new()
		newLabel.text = ""
		if debugTheme != null:
			newLabel.theme = debugTheme
		
		newLabel.hide() # Initially hide labels with no text
		labelSlots.append(newLabel)
		vBoxContainer.add_child(newLabel)

func _process(_delta: float) -> void:
	# Get the mouse position within the game viewport
	var mouse_position = get_viewport().get_mouse_position()
	mouse_position = Vector2(round(mouse_position.x), round(mouse_position.y))

	# Display the coordinates in the Label
	mousePositionLabel.text = "Mouse Position: " + str(mouse_position)
