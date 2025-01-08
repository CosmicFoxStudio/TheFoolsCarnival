class_name Player extends Character

# enum ePlayerState { ACTIVE, INACTIVE, TALKING, MENU, WARPING }

# Get input dynamically (read-only)
var direction: float:
	get:
		return Input.get_axis("move_left", "move_right") * properties.speed
var jump: float:
	get: return Input.is_action_pressed("jump")
var attack: bool:
	get: return Input.is_action_just_pressed("basic_attack")

# Keyboard Pressure Variables
var minPressure: float = 0.8
var maxPressure: float = 8.0
var pressureThreshold: float = 8.0
var pressure: float = 0.0

func _ready() -> void:
	super()
	type = eType.PLAYER
	
	# Get player properties
	if Global.playerResource != null:
		properties = Global.playerResource

func _process(delta: float) -> void:
	super(delta)
	
	if (Global.pause):
		ChangeState(eState.IDLE)

	## Handle pressure logic only when jump is pressed
	#if jump:
		#pressure += delta * 10.0
	#else:
		#pressure -= delta * 15.0
#
	## Clamp pressure between min and max
	#pressure = clamp(pressure, minPressure, maxPressure)

func EnablePlayerMovement() -> void:
	if direction:
		velocity.x = direction * properties.speed
	else:
		velocity.x = move_toward(velocity.x, 0, properties.speed)

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

func StateWalk(_delta) -> void:
	if dead or isAttacking: return
	
	PlayAnimation("walk")
	EnablePlayerMovement()
	Flip()
	
	if not direction: ChangeState(eState.IDLE)
	if jump: ChangeState(eState.JUMP)
	if attack: ChangeState(eState.ATTACK)

# Handle input for jumping
func StateJump() -> void:
	if dead: return
	
	PlayAnimation("jump")
	EnablePlayerMovement()
	
	if is_on_floor():
		# Ensure pressure starts at minimum when jump is triggered
		if pressure <= minPressure:
			pressure = minPressure
		
		# Build pressure while the jump key is held
		if Input.is_action_pressed("jump"):
			pressure += get_process_delta_time() * 20.0  # Faster pressure accumulation
			pressure = clamp(pressure, minPressure, maxPressure)
		else:
			# Apply jump velocity when jump key is released
			var defaultJumpStrength = 0.5  # Default jump strength (50% of max)
			var jumpStrength = max(defaultJumpStrength, pressure / maxPressure)
			velocity.y = -properties.jumpVelocity * jumpStrength
			print("Jumping with strength:", jumpStrength, "Velocity:", velocity.y)
			
			# Reset pressure for the next jump
			pressure = 0
	
	# Transition to falling state if airborne
	if velocity.y > 0:
		ChangeState(eState.FALL)

func StateFall() -> void:
	PlayAnimation("fall")
	EnablePlayerMovement()

	# Transition to idle when landing
	if is_on_floor():
		print("Is on floor")
		ChangeState(eState.IDLE)

func StateAttack() -> void:
	if dead: return

	StopMovement()

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
		Global.sceneTransition.transition("res://scenes/screens/menu_interface.tscn")

func _physics_process(delta: float) -> void: 
	super(delta)
	
	# Clamps the player position to the camera boundaries
	var camPos = Global.level.camera.position.x
	var camLimit = Global.level.camera.clampedPos.x
	# var camLimit = Global.level.areaMarkers[Global.level.currentSegmentIndex].position.x
	
	if camPos != null and camLimit != null:
		position.x = clamp(position.x, camPos - camLimit, camLimit)
	else:
		print("Camera positions not properly set.")
		
	# position.x = clamp(position.x, Global.level.camera.position.x - 640, Global.level.camera.clampedPos.x + 640)

func _debug() -> void:
	Global.debug.UpdateDebugVariable(0, "Velocity: " + str(velocity))
	Global.debug.UpdateDebugVariable(1, "State: " + str(eState.keys()[state]))
	Global.debug.UpdateDebugVariable(2, "Direction: " + str(direction))
	#Global.debug.UpdateDebugVariable(3, "Jump: " + str(jump))
	#Global.debug.UpdateDebugVariable(4, "Attack: " + str(attack))
	Global.debug.UpdateDebugVariable(3, "Is attacking?: " + str(isAttacking))
	Global.debug.UpdateDebugVariable(4, "Combo Index: " + str(comboIndex))
	Global.debug.UpdateDebugVariable(5, "Camera Pos: " + str(Global.level.camera.position.x) + " / " + str(Global.level.camera.position.y))
	Global.debug.UpdateDebugVariable(6, "Camera Clamped Pos: " + str(Global.level.camera.clampedPos.x) + " / " + str(Global.level.camera.clampedPos.y)) 
	Global.debug.UpdateDebugVariable(7, "Segment Index: " + str(Global.level.currentSegmentIndex))
	Global.debug.UpdateDebugVariable(8, "Last Area?: " + str(Global.level.lastArea))
	Global.debug.UpdateDebugVariable(9, "DramaMeter: " + str(Global.level.HUD.dramaMeter.audienceValue))

	# Console
	#if state == eState.ATTACK: Global.debug.DebugPrint("Combo Timer Running: " + str(comboTimer.is_stopped() == false) + " Time Left: " + str(comboTimer.time_left))
	
