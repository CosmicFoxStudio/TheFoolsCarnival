extends Enemy

var targetDistance : Vector2 # Distance to player

# State Overrides
func StateIdle() -> void:
	if dead: return
	
	if enterState:
		enterState = false
	
		# For safety, reset variables
		isAttacking = false
		comboIndex = 0
		comboTimer.stop()

		PlayAnimation("idle")
		StopMovement()
		
		# Wait a random amount of time in idle state
		AITimer.wait_time = randf_range(1, 2)
		AITimer.start()
		
		hurtIndex = 0 # Reset hurt/down state

		# Automatically change to walk after timeout
		await AITimer.timeout
		ChangeState(eState.WALK)

func StateWalk(delta) -> void:
	if dead: return

	if enterState:
		enterState = false

		velocity = Vector2.ZERO # Velocity starts at zero

		# Wait a random amount of time in walk state
		AITimer.wait_time = randf_range(2, 4)
		AITimer.start()

		# Automatically change to idle after timeout
		await AITimer.timeout
		ChangeState(eState.IDLE)

	# =============================================
	#  ============== AI MOVEMENT ===============
	# This code executes before the timer timeout
	# =============================================
	
	# Distance to the player position
	targetDistance = Global.level.player.position - self.position
	
	# Horizontal Movement (move toward the player's x position)
	# sign() ensures the enemy moves left (-1) or right (1) based on the player's position
	self.velocity.x = sign(targetDistance.x) * speed * delta
	
	# Walks for a random duration between 1s and 2s
	walkTimer += delta
	if walkTimer >= randf_range(1, 2): 
		walkTimer = 0 # Reset timer

	# Attack the player when a certain distance is reached
	if abs(targetDistance.x) < distanceAttack:
		# Stops moving before reaching the player position to attack
		self.velocity.x = 0
		
	# Start attack
	if abs(targetDistance.x) < distanceAttack:
		velocity.x = 0
		ChangeState(eState.ATTACK)

	PlayAnimation("idle" if velocity == Vector2.ZERO else "walk")
	Flip() # Only flips towards the player while in walk state
	move_and_slide()
	
func StateAttack() -> void: 
	print("Enemy is in ATTACK state.")
	
	# Example AI logic to decide when to attack (25% chance to start attacking)
	#if randi() % 4 == 0: ChangeState(eState.ATTACK)

func _debug() -> void:
	Global.debug.UpdateDebugVariable(8, "Velocity X: " + str(velocity.x))
	Global.debug.UpdateDebugVariable(9, "Velocity Y: " + str(velocity.y))
	Global.debug.UpdateDebugVariable(10, "State: " + str(eState.keys()[state]))
	Global.debug.UpdateDebugVariable(11, "Is attacking?: " + str(isAttacking))
	Global.debug.UpdateDebugVariable(12, "Combo Index: " + str(comboIndex))
	Global.debug.UpdateDebugVariable(13, "AI Timer Running: " + str(AITimer.is_stopped() == false) + " Time Left: " + str(AITimer.time_left))
	
