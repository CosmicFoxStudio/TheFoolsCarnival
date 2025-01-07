class_name AudienceMeter extends TextureProgressBar

signal sOnMeterChanged(value:float)
signal sOnMeterReachedZero

@export var minValColor : Color
@export var maxValColor : Color
@export var meterCurve : Curve
@export var meterArrow : TextureRect

var meter : float
var fillBar : StyleBoxFlat
var meterZero : bool

func _ready() -> void:
	fillBar = get_theme_stylebox("fill", "ProgressBar")	
	meter = max_value

func _process(delta: float) -> void:
	meter -= delta;
	meter = clampf(meter, min_value, max_value)
	
	fillBar.bg_color = lerp(minValColor, maxValColor, meter / max_value) # 
	
	value = meter
	
	meterArrow.rotation_degrees = (meter * 5)
	meterArrow.rotation_degrees = clampf(meterArrow.rotation_degrees, -50,50)
	
	if(meter <= min_value && not meterZero):
		sOnMeterReachedZero.emit()
		meterZero = true
		print("Meter reached ZERO")
		

func add_meter(amount: float):
	meter += amount
	if(meter >= max_value):
		meter = max_value
		
	sOnMeterChanged.emit(meter)

func _on_player_lower_approval(points: int):
	meter -= points
