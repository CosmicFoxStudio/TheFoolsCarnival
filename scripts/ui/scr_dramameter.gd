class_name DramaMeter extends TextureProgressBar

# enum eDramaLevel { RED, ORANGE, YELLOW, GREEN, BLUE }
# Signals (not using atm)
# signal sOnMeterChanged(value:float)
# signal sOnMeterReachedZero

@export var decayRate: float = 1.0  # Decay rate per second
@export var comboBonusMultiplier: float = 1.1  # Bonus for combos
@export var maxMeter: int = 100
@export var minMeter: int = 0
@export var overlayTextures: Array[CompressedTexture2D]

# Current meter value
var audienceValue: float = 50.0  # Start at 50%

func _ready():
	value = audienceValue  # Sync meter value with progress bar
	UpdateOverlay()
	
	# Connect the DecayTimer timeout signal (Already connected through Godot UI)
	# $DecayTimer.timeout.connect(_on_DecayTimer_timeout)

func IncreaseMeter(__points: float):
	# Increase the meter
	audienceValue += __points
	audienceValue = clamp(audienceValue, minMeter, maxMeter)
	value = audienceValue
	UpdateOverlay()

func DecreaseMeter(delta: float):
	# Gradually decrease the meter over time
	audienceValue -= decayRate * delta
	audienceValue = max(audienceValue, minMeter)
	value = audienceValue
	UpdateOverlay()

func GetAudienceLevel() -> String:
	if audienceValue < 20:
		return "Red"
	elif audienceValue < 40:
		return "Orange"
	elif audienceValue < 60:
		return "Yellow"
	elif audienceValue < 80:
		return "Green"
	else:
		return "Blue"

func IsStageFailed() -> bool:
	return audienceValue < 20  # Fail if in the red zone

func UpdateOverlay():
	# Update the overlay texture based on the current level
	var level = GetAudienceLevel()
	match level:
		"Red":
			texture_over = overlayTextures[0]
		"Orange":
			texture_over = overlayTextures[1]
		"Yellow":
			texture_over = overlayTextures[2]
		"Green":
			texture_over = overlayTextures[3]
		"Blue":
			texture_over = overlayTextures[4]

func _on_decay_timer_timeout() -> void:
	# Gradually decrease the meter each tick
	DecreaseMeter($DecayTimer.wait_time)
