class_name EnemySentinel extends Character

# AI-related states
enum eAIState { PATROL, CHASE, ATTACK, RETURN }

# AI-specific variables
@export var patrol_speed: float = 100.0
@export var detection_range: float = 300.0
@export var attack_range: float = 50.0
@export var patrol_pause_time: float = 1.0 # Time to pause at patrol points

# Patrol start and end points
@export var patrol_points: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]

# Private variables
var current_patrol_point: int = 0
var ai_state: eAIState = eAIState.PATROL
var detection_target: Node2D = null
var pause_timer: float = 0.0

# AI logic flags
var player_detected: bool = false
var is_patrolling: bool = true

# Custom logic to decide AI attack behavior
#func ContinueCombo() -> bool:
	#return randi() % 2 == 0  # 50% chance to continue combo

# Initialization
func _ready() -> void:
	super()
	type = eType.ENEMY
	
	# Initialize the current patrol point
	current_patrol_point = 0
	position = patrol_points[current_patrol_point]

	# Ensure there are at least two patrol points
	if patrol_points.size() < 2:
		print("Error: Sentinel needs at least two patrol points.")
		set_process(false)

func _physics_process(delta: float) -> void:
	match ai_state:
		eAIState.PATROL: PatrolBehavior(delta)
		eAIState.CHASE: ChaseBehavior(delta)
		eAIState.ATTACK: AttackBehavior(delta)
		eAIState.RETURN: ReturnToPatrolBehavior(delta)

	# Call parent function
	super(delta)
	#ApplyGravity(delta)
	#move_and_slide()

func PatrolBehavior(delta: float) -> void:
	# Move towards the current patrol point
	var target_position = patrol_points[current_patrol_point]
	MoveTowardsTarget(target_position, patrol_speed)

	# Check if we've reached the patrol point
	if position.distance_to(target_position) < 5.0:
		# Pause at the patrol point before switching
		if pause_timer <= 0:
			pause_timer = patrol_pause_time
			current_patrol_point = (current_patrol_point + 1) % patrol_points.size()
		else:
			pause_timer -= delta

	# Check for player detection
	var player = DetectPlayer()
	if player:
		detection_target = player
		ai_state = eAIState.CHASE

func ChaseBehavior(_delta: float) -> void:
	if not detection_target:
		ai_state = eAIState.RETURN
		return
	
	# Move towards the detected player
	MoveTowardsTarget(detection_target.position, speed)
	
	# Check if the player is in attack range
	if position.distance_to(detection_target.position) <= attack_range:
		ai_state = eAIState.ATTACK
	
	# If the player goes out of detection range, return to patrol
	if position.distance_to(detection_target.position) > detection_range:
		ai_state = eAIState.RETURN

func AttackBehavior(_delta: float) -> void:
	# Stop moving and attack
	StopMovement()
	PlayAnimation("attack1")
	
	# Attack logic can go here (e.g., reduce player health)
	if not isAttacking:
		isAttacking = true
		# Attack player (damage logic goes here)
		isAttacking = false
	
	# Return to chase if player moves out of attack range
	if detection_target and position.distance_to(detection_target.position) > attack_range:
		ai_state = eAIState.CHASE

func ReturnToPatrolBehavior(_delta: float) -> void:
	# Return to the nearest patrol point
	var target_position = patrol_points[current_patrol_point]
	MoveTowardsTarget(target_position, patrol_speed)

	# If back at patrol point, resume patrolling
	if position.distance_to(target_position) < 5.0:
		ai_state = eAIState.PATROL
		detection_target = null

# Utility function to move towards a target position
func MoveTowardsTarget(target_position: Vector2, move_speed: float) -> void:
	var direction = (target_position - position).normalized()
	velocity.x = direction.x * move_speed
	velocity.y = velocity.y # Preserve vertical movement due to gravity
	Flip()

# Detect player within range
func DetectPlayer() -> Node2D:
	var player = get_tree().get_current_scene().get_node("Player")
	if player and position.distance_to(player.position) <= detection_range:
		return player
	return null

# State Overrides
func StateIdle() -> void:
	if dead: return
	PlayAnimation("idle")
	StopMovement()

	# Example AI logic to decide when to attack (25% chance to start attacking)
	if randi() % 4 == 0: ChangeState(eState.ATTACK)

func StateWalk() -> void: print("Enemy WALK state")

func StateJump() -> void:
	if is_on_floor():
		velocity.y = -properties.jump_velocity
		PlayAnimation("jump")

func StateFall() -> void: print("Enemy FALL state")
func StateAttack() -> void: pass #HandleAttack(0)
func StateAttack2() -> void: pass #HandleAttack(1)

# Review this later
func ChangeState(new_state: eState) -> void:
	# Example state change for attacks and other actions
	state = new_state
	
	match state:
		eState.IDLE: StateIdle()
		eState.WALK: StateWalk()
		eState.ATTACK: StateAttack()
		eState.FALL: StateFall()
