extends Enemy

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
	super(delta)
	
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
	
	# Horizontal Movement (move toward the player's x position)
	# sign() ensures the enemy moves left (-1) or right (1) based on the player's position
	self.velocity.x = sign(targetDistance.x) * properties.speed * delta
	
	# DEBUG
	#print(
		#"Char: %s, 
		#Direction: %s, 
		#Speed (properties): %s, 
		#Delta: %s, 
		#Final Velocity: %s" % 
		#[get_name(), sign(targetDistance.x), properties.speed, delta, velocity]
	#)
	
	# Walks for a random duration between 1s and 2s
	walkTimer += delta
	if walkTimer >= randf_range(1, 2): 
		walkTimer = 0 # Reset timer

	# Attack the player when a certain distance is reached
	if abs(targetDistance.x) < distanceAttack:
		# Stops moving before reaching the player position to attack
		self.velocity.x = 0
		
		# Start attack
		# if attackBox.get_overlapping_bodies().has(Global.level.player.hitbox):
		if abs(targetDistance.x) < distanceAttack:
			velocity.x = 0
			ChangeState(eState.ATTACK)

	PlayAnimation("idle" if velocity == Vector2.ZERO else "walk")
	Flip() # Only flips towards the player while in walk state
	move_and_slide()
	
	# Example AI logic to decide when to attack (25% chance to start attacking)
	# if randi() % 4 == 0: ChangeState(eState.ATTACK)
	
func StateAttack() -> void: 
	if dead or Global.level.player.dead: return

	if enterState:
		enterState = false
		StopMovement()
		StartAttackCollision()
		PlayAnimation("attack1")
		isAttacking = true

		# Ensure the animation_finished signal is connected
		if not animationPlayer.animation_finished.is_connected(OnEnemyAnimationFinished):
			animationPlayer.animation_finished.connect(OnEnemyAnimationFinished)

func OnEnemyAnimationFinished(__animName: String) -> void:
	if __animName == "attack1":
		EndAttackCollision()
		isAttacking = false
		ChangeState(eState.IDLE)

func StateHurt() -> void:
	if enterState:
		enterState = false
		PlayAnimation("hurt")
		Global.effects.spawn_effect(effectResource, global_position)

		AITimer.stop()
		AITimer.wait_time = randf_range(0.5, 1)
		AITimer.start()

		await AITimer.timeout
		ChangeState(eState.IDLE)

func StateDown() -> void:
	if enterState:
		enterState = false

		# Down animation and VFX
		SetHurtThrow()
		await AITimer.timeout
		
		ChangeState(eState.UP)

	# Physics
	move_and_slide()

	AITimer.stop()
	AITimer.wait_time = randf_range(1, 2)
	AITimer.start()

func StateUp() -> void:
	if enterState:
		enterState = false
		PlayAnimation("up")
		await animationPlayer.animation_finished
		
		# Can receive damage after getting up
		hitboxCollision.disabled = false
		
		ChangeState(eState.IDLE)

func StateDied() -> void:
	super()
	
	if enterState:
		enterState = false
		dead = true

		#PlaySound(SOUNDS[2]) # Play death sound

		# Down animation and VFX
		SetHurtThrow()
		
		# Update enemy HUD 
		Global.level.HUD.HudUpdateEnemy(properties, 0)

		await AITimer.timeout
		velocity.x = 0 # To prevent the death sliding

		PlayAnimation("died")

		# Death VFX (flicker sprite)
		for i in range(8):
			sprite.visible = not sprite.visible
			await get_tree().create_timer(0.1).timeout
		# Makes the enemy disappear after being defeated
		sprite.hide()
		
		# Tells the Level Controller this enemy has died
		Global.level.EnemyDied()
		
		# Removes the node safely
		queue_free()
	
	# Physics
	move_and_slide()

func OnDamage(__health: float) -> void:
	# Update enemy HUD 
	Global.level.HUD.HudUpdateEnemy(properties, __health)
	
	hurtIndex += 1 # Reset is on idle state
	match hurtIndex:
		1: 
			# PlaySound(SOUNDS[0])
			ChangeState(eState.HURT)
		2: 
			# PlaySound(SOUNDS[1])
			ChangeState(eState.DOWN)

func _debug() -> void:
	Global.debug.UpdateDebugVariable(13, "Velocity: " + str(velocity))
	Global.debug.UpdateDebugVariable(14, "State: " + str(eState.keys()[state]))
	Global.debug.UpdateDebugVariable(15, "Is attacking?: " + str(isAttacking))
	Global.debug.UpdateDebugVariable(16, "Combo Index: " + str(comboIndex))
	Global.debug.UpdateDebugVariable(17, "AI Timer Running: " + str(AITimer.is_stopped() == false) + " Time Left: " + str(AITimer.time_left))
	Global.debug.UpdateDebugVariable(18, "Distance to player: " + str(targetDistance.x))
