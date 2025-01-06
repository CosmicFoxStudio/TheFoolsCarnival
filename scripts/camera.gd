extends Camera2D

const SCREEN_WIDTH : float = 640.0
const SCREEN_HEIGHT : float = 360.0

var smooth := 4.0
var initialPos := 0.0
var clampedPos := 0.0 # Start at half the screen width

func _process(delta: float) -> void:
	# Ensure the camera only moves forward
	if position.x < Global.level.player.position.x:
		# Smoothly follow the player's X position
		position.x = lerp(position.x, Global.level.player.position.x, smooth * delta)

		# Clamp the camera within its current boundaries
		position.x = clamp(position.x, initialPos, clampedPos)

func SetCameraLimit(__limit: float) -> void:
	# Update the rightmost limit of the camera
	clampedPos = __limit

#func AdvanceToNextArea(enemies_beaten: int, total_enemies: int) -> void:
	## Calculate the new camera limit based on player progression
	#if enemies_beaten >= total_enemies:
		## Move the camera to the next area
		#initialPos = clampedPos
		#clampedPos += SCREEN_WIDTH.to_float()
