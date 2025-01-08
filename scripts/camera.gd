extends Camera2D

@export var smoothFactor : float = 5.0  # Smoothness of the camera movement
@export var cameraOffset : Vector2 = Vector2(0, 0)  # Offset from the player's center

var targetPosition : Vector2
var currentPosition : Vector2
var clampedPos : Vector2 = Vector2(0.0, 0.0)  # X and Y-bounds for the camera movement
var currentSegmentBoundary : Vector2 # Camera's current segment's boundary

func _ready() -> void:
	# Initialize the camera's position relative to the player
	position = Global.level.player.position + cameraOffset
	currentPosition = position

func _process(delta: float) -> void:
	# Target position follows the player with an offset	
	targetPosition = Global.level.player.position + cameraOffset

	# Smoothly interpolate the camera's position towards the target
	currentPosition = lerp(currentPosition, targetPosition, smoothFactor * delta)
	# limit_right = 
	
	# Clamp the camera to stay within bounds
	currentPosition.x = clamp(currentPosition.x, 0.0, clampedPos.x)
#
	# Apply the new position to the camera 
	# (Because we use top-left anchor, position.x, position.y is the camera's top-left corner)
	position = currentPosition

# Update the camera limits when advancing to the next segment
func SetCameraLimit(__newLimit: Vector2) -> void:
	limit_right = __newLimit.x # Big band-aid but IT WORKS!! LOL
	clampedPos = __newLimit

func UpdateSegmentBoundary(newBoundary: Vector2) -> void:
	# Update the segment's boundary when transitioning
	currentSegmentBoundary = newBoundary
