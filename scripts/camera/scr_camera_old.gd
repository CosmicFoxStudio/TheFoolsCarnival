extends Camera2D

# Camera Anchor is top-left

@export var smoothFactor : float = 5.0  # Smoothness of the camera movement
@export var cameraOffset : Vector2 = Vector2(0, 0)  # Offset from the player's center

#@onready var limitManager: CameraLimitManager = $LimitManager

var targetPosition : Vector2
var currentPosition : Vector2
var clampedPos : Vector2 = Vector2(0.0, 0.0)  # X and Y-bounds for the camera movement
var targetClampedPos : Vector2 = Vector2(0.0, 0.0)  # Target X and Y bounds for smoothing transitions
var currentSegmentBoundary : Vector2

var limitSmoothFactor : float = 2.0

func _ready() -> void:
	position = Global.level.player.position + cameraOffset
	currentPosition = position
	targetClampedPos = clampedPos

func _process(delta: float) -> void:
	# Smoothly update the limits
	clampedPos = lerp(clampedPos, targetClampedPos, limitSmoothFactor * delta)

	# Target position follows the player with an offset
	targetPosition = Global.level.player.position + cameraOffset

	# Smoothly interpolate the camera's position towards the target
	currentPosition = lerp(currentPosition, targetPosition, smoothFactor * delta)

	# Clamp the camera to stay within the smoothly transitioning bounds
	currentPosition.x = clamp(currentPosition.x, 0.0, clampedPos.x)

	# Apply the new position to the camera
	position = currentPosition

func SetCameraLimit(newLimit: Vector2) -> void:
	# currentPosition = lerp(limit_right, int(newLimit.x), 5.0)
	limit_right = newLimit.x # Big band-aid but IT WORKS!! LOL
	
	# Set the target for the limit transition
	targetClampedPos = newLimit

func UpdateSegmentBoundary(newBoundary: Vector2) -> void:
	# Update the segment's boundary when transitioning
	currentSegmentBoundary = newBoundary
