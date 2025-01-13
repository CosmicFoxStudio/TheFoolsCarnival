class_name Player extends Character

# enum ePlayerState { ACTIVE, INACTIVE, TALKING, MENU, WARPING }

@onready var camera: Camera = $Camera
@onready var player_audio_stream: AudioStreamPlayer2D = $PlayerAudioStream

# Get input dynamically (read-only)
var direction: float:
	get: return Input.get_axis("move_left", "move_right")
var jump: float:
	get: return Input.is_action_just_pressed("jump")
var attack: bool:
	get: return Input.is_action_just_pressed("basic_attack")

# Keyboard Pressure Variables
#var minPressure: float = 0.8
#var maxPressure: float = 8.0
#var pressureThreshold: float = 8.0
#var pressure: float = 0.0

var defaultJumpStrength = 0.6  # Default jump strength (80% of max)
var jumpAcceleration = 0.03
var jumpStrength = defaultJumpStrength
var canHoldJump = true

func _ready() -> void:
	super()
	type = eType.PLAYER
	
	# Set initial position on the room (directly on ground)
	# position = Vector2(80, Global.FLOOR)
	
	# Spawn falling
	position = Vector2(80, 300)
	ChangeState(eState.FALL)
	
	# Get player properties
	if Global.playerResource != null:
		properties = Global.playerResource

func _process(delta: float) -> void:
	super(delta)
	
	if (Global.pause): ChangeState(eState.IDLE)

func EnablePlayerMovement(delta) -> void:
	# (FIX-ME) For some weird reason, player has much higher speed but moves slower than enemies)
	if direction: velocity.x = direction * properties.speed
	else: velocity.x = move_toward(velocity.x, 0, properties.speed)
	
	# DEBUG 
	#print(
		#"Char: %s, 
		#Direction: %s, 
		#Speed (properties): %s, 
		#Delta: %s, 
		#Final Velocity: %s" % 
		#[get_name(), direction, properties.speed, delta, velocity]
	#)

# State Overrides
func StateIdle() -> void:
	if dead: return
	
	# For safety, reset variables
	isAttacking = false
	comboIndex = 0
	comboTimer.stop()
	
	PlayAnimation("idle")
	StopMovement()
	
	if direction: ChangeState(eState.WALK)
	if jump: ChangeState(eState.JUMP)
	if attack: ChangeState(eState.ATTACK)

func StateWalk(delta) -> void:
	if dead or isAttacking: return
	
	PlayAnimation("walk")
	EnablePlayerMovement(delta)
	Flip()
	
	if not direction: ChangeState(eState.IDLE)
	if jump: ChangeState(eState.JUMP)
	if attack: ChangeState(eState.ATTACK)

# Handle input for jumping
func StateJump(delta) -> void:
	if dead: return
	
	if velocity.y > 0:
		ChangeState(eState.FALL)
		return
	
	PlayAnimation("jump")
	EnablePlayerMovement(delta)
	
	if is_on_floor():
		# Ensure pressure starts at minimum when jump is triggered	
		canHoldJump = true	
		jumpStrength = defaultJumpStrength
		velocity.y = -properties.jumpVelocity * defaultJumpStrength
		
	if not canHoldJump: return
		
	if Input.is_action_just_released("jump") or jumpStrength >= 1:
		canHoldJump = false
		return
	
	var previousJumpStrength = jumpStrength
	
	jumpStrength += jumpAcceleration  # Faster pressure accumulation
	jumpStrength = clamp(jumpStrength, defaultJumpStrength, 1)
	velocity.y -= properties.jumpVelocity * (jumpStrength - previousJumpStrength)
	print("Jumping with strength:", jumpStrength, "Velocity:", velocity.y)
		# Reset pressure for the next jump
	
	# Transition to falling state if airborne

func StateFall(delta) -> void:
	PlayAnimation("fall")
	EnablePlayerMovement(delta)

	# Transition to idle when landing
	if is_on_floor():
		print("Is on floor")
		ChangeState(eState.IDLE)

func StateAttack() -> void:
	if dead: return

	StopMovement()

	player_audio_stream["parameters/switch_to_clip"] = "ATTACK"
	
	# Connect the animation_finished signal if not already connected
	if not animationPlayer.animation_finished.is_connected(OnAnimationFinished):
		animationPlayer.animation_finished.connect(OnAnimationFinished)

	# Combo logic
	if not comboTimer.is_stopped():
		if attack:  # Player pressed attack again
			if comboIndex == 1:
				var playerComboMultiplier = 1
				print("Second attack triggered")
				StartAttackCollision()
				animationPlayer.play("attack2")
				comboIndex += 1
				
				# Update DramaMeter
				Global.level.HUD.dramaMeter.IncreaseMeter(10 * playerComboMultiplier)
				
				#comboTimer.stop()
				#comboTimer.start()

	if comboIndex == 0:
		print("First attack triggered")
		StartAttackCollision()
		animationPlayer.play("attack1")
		comboIndex += 1
		isAttacking = true
		comboTimer.wait_time = 0.8
		comboTimer.start()
		
		
		

func OnAnimationFinished(__animName: String) -> void:
	EndAttackCollision()
	
	if __animName in ["attack1", "attack2"]:
		isAttacking = false
		
		ChangeState(eState.IDLE)
		# DEBUG
		# print(__animName, " finished, returning to idle")

func OnDamage(__health: float) -> void:
	# Update DramaMeter
	var enemyComboMultiplier = 2
	Global.level.HUD.dramaMeter.DecreaseMeter(10 * enemyComboMultiplier)
	player_audio_stream.play()

func StateHurt() -> void:
	if enterState:
		enterState = false
		
		PlayAnimation("hurt")
		StopMovement()
		
		# Update HUD
		Global.level.HUD.HudUpdateHealth(health.hp)
	
	# Wait 0.5 seconds before changing state
	await get_tree().create_timer(0.5).timeout
	ChangeState(eState.IDLE)

func StateDied() -> void:
	if enterState:
		enterState = false
		PlayAnimation("died")
		dead = true
		StopMovement()
		
		# Update HUD
		Global.level.HUD.HudUpdateHealth(health.hp)
		
		# Death VFX (flicker sprite)
		for i in range(8):
			sprite.visible = not sprite.visible
			await get_tree().create_timer(0.1).timeout

		# Makes the player disappear after being defeated
		sprite.hide()
		# if shadow != null: shadow.hide()
		
		# Change back to menu after 2 seconds
		await get_tree().create_timer(2).timeout
		
		# Scene transition (TO-DO: Add pixilate transition here)
		#Global.sceneTransition.transition("res://scenes/screens/menu_interface.tscn")
		Global.level.EndGame()
		
func _physics_process(delta: float) -> void: 
	super(delta)
	
	# Clamps the player position to the camera boundaries
	var camPos = camera.position.x
	# var camLimit = camera.clampedPos.x
	var camLimit = Global.level.camLimiters[Global.level.currentSegmentIndex].position.x
	
	if camPos != null and camLimit != null:
		position.x = clamp(position.x, camPos - camLimit, camLimit)
	else:
		print("Camera positions not properly set.")

func _debug() -> void:
	Global.debug.UpdateDebugVariable(0, "Velocity: " + str(velocity))
	Global.debug.UpdateDebugVariable(1, "State: " + str(eState.keys()[state]))
	Global.debug.UpdateDebugVariable(2, "Direction: " + str(direction))
	#Global.debug.UpdateDebugVariable(3, "Jump: " + str(jump))
	#Global.debug.UpdateDebugVariable(4, "Attack: " + str(attack))
	Global.debug.UpdateDebugVariable(3, "Is attacking?: " + str(isAttacking))
	Global.debug.UpdateDebugVariable(4, "Combo Index: " + str(comboIndex))
	Global.debug.UpdateDebugVariable(5, "DramaMeter: " + str(Global.level.HUD.dramaMeter.audienceValue))
	Global.debug.UpdateDebugVariable(6, "Player Pos: " + str(position))
	#Global.debug.UpdateDebugVariable(7, "Player Global Pos: " + str(global_position))
	
	# Console
	#if state == eState.ATTACK: Global.debug.DebugPrint("Combo Timer Running: " + str(comboTimer.is_stopped() == false) + " Time Left: " + str(comboTimer.time_left))
