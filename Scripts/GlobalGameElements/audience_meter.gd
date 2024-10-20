extends ProgressBar

class_name AudienceMeter

@export var min_val_color : Color
@export var max_val_color : Color

@export var meterCurve : Curve
var meter : float

var fillBar : StyleBoxFlat

var meterZero : bool

signal on_meter_changed(value:float)
signal on_meter_reached_zero

func _ready() -> void:
	fillBar = get_theme_stylebox("fill", "ProgressBar")	
	meter = max_value

func _process(delta: float) -> void:
	meter -= delta;
	meter = clampf(meter, min_value, max_value)
	 
	fillBar.bg_color = lerp(min_val_color, max_val_color, meter / max_value) # 
	
	value = meter
	
	if(meter <= 0 && not meterZero):
		on_meter_reached_zero.emit()
		meterZero = true
		print("Meter reached ZERO")
	
func add_meter(amount: float):
	meter += amount
	if(meter >= max_value):
		meter = max_value
		
	on_meter_changed.emit(meter)
	
	


func _on_player_lower_approval(value:int):
	meter -= value
