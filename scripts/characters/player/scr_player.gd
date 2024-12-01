class_name Player extends Character

@onready var audioStreamPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

# enum ePlayerState { ACTIVE, INACTIVE, TALKING, MENU, WARPING } # Not being used at the moment

# Get input dynamically (read-only)
var direction: float:
	get:
		return Input.get_axis("move_left", "move_right") * properties.speed
var jump: float:
	get: return Input.is_action_pressed("jump")
var attack: bool:
	get: return Input.is_action_just_pressed("basic_attack")

# Jump variables
var minPressure: float = 20.0
var maxPressure: float = 40.0
var pressureThreshold: float = 30.0
var pressure: float = 0.0
var jump_time: float = 0.0
var max_jump_time: float = 0.3  # Maximum time (in seconds) the jump can build height

func _ready() -> void:
	super()
	type = eType.PLAYER
	
	# Get player properties
	if Global.playerResource != null:
		properties = Global.playerResource

func _process(delta: float) -> void:
	super(delta)

	if Global.pause:
		ChangeState(eState.IDLE)

	# JUMP
	if jump and (state == eState.JUMP or state == eState.IDLE):
		pressure += delta * 10.0
	elif not jump:
		pressure -= delta * 15.0

	pressure = clamp(pressure, minPressure, maxPressure)

func _debug() -> void:
	Global.debug.UpdateDebugVariable(0, "Velocity X: " + str(velocity.x))
	Global.debug.UpdateDebugVariable(1, "Velocity Y: " + str(velocity.y))
	Global.debug.UpdateDebugVariable(2, "State: " + str(eState.keys()[state]))
	Global.debug.UpdateDebugVariable(3, "Direction: " + str(direction))
	Global.debug.UpdateDebugVariable(4, "Jump: " + str(jump))
	Global.debug.UpdateDebugVariable(5, "Attack: " + str(attack))

func EnablePlayerMovement() -> void:
	if direction:
		velocity.x = direction * properties.speed
	else:
		velocity.x = move_toward(velocity.x, 0, properties.speed)

# State Overrides
func StateIdle() -> void:
	if dead: return
	
	PlayAnimation("idle")
	StopMovement()
	
	if direction: ChangeState(eState.WALK)
	if jump: ChangeState(eState.JUMP)
	if attack: ChangeState(eState.ATTACK1)

func StateWalk() -> void:
	if dead: return
	
	PlayAnimation("walk")
	EnablePlayerMovement()
	Flip()
	
	if not direction: ChangeState(eState.IDLE)
	if jump: ChangeState(eState.JUMP)
	if attack: ChangeState(eState.ATTACK1)

func StateJump() -> void:
	if dead: return

	PlayAnimation("jump")
	EnablePlayerMovement()

	# Initial jump and pressure handling
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		pressure = minPressure
		velocity.y = -properties.jump_velocity * (pressure / maxPressure)
		jump_time = 0.0

	# Building jump height while button is held
	if Input.is_action_pressed("jump") and jump_time < max_jump_time:
		jump_time += get_process_delta_time()
		#pressure += get_process_delta_time() * 10.0
		#pressure = clamp(pressure, minPressure, maxPressure)
		velocity.y = -properties.jump_velocity * (pressure / maxPressure)

	if Input.is_action_just_released("jump") or pressure >= maxPressure or jump_time >= max_jump_time:
		pressure = 0

	if velocity.y > 0:
		ChangeState(eState.FALL)

func StateFall() -> void:
	PlayAnimation("fall")
	EnablePlayerMovement()

	# Transition to idle when landing
	if is_on_floor():
		print("Is on floor")
		ChangeState(eState.IDLE)

func UpdatePlayerAudio(__audio: String) -> void:
	if __audio == null: 
		audioStreamPlayer.stop()
