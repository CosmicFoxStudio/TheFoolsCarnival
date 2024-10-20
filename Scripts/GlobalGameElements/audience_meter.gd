extends ProgressBar

@export var min_val_color : Color
@export var max_val_color : Color

@export var meterCurve : Curve
var meter : float

var fillBar : StyleBoxFlat

signal on_meter_changed(value:float)

func _ready() -> void:
	fillBar = get_theme_stylebox("fill", "ProgressBar")	
	meter = max_value
	print(fillBar)

func _process(delta: float) -> void:
	meter -= delta;
	meter = clampf(meter, min_value, max_value)
	 
	fillBar.bg_color = lerp(min_val_color, max_val_color, meter / max_value) # 
	
	value = meter
	
func add_meter(amount: float):
	meter += amount
	if(meter >= max_value):
		meter = max_value
		
	on_meter_changed.emit(meter)
	
	
