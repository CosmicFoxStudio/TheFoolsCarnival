class_name Character extends CharacterBody2D

enum eState { IDLE, WALK, JUMP, FALL, ATTACK1, ATTACK2, HURT, DIED }
enum eType { PLAYER, ENEMY, NPC }

# Shared properties
@export var properties: CharacterData
@export var speed: float = 200.0
@export var maxHealth: int = 100

# Variables
var type : eType
var state : eState = eState.IDLE
var enterState: bool = true
var currentHealth: int
var isAttacking: bool = false
var dead : bool = false

@onready var camera: Camera2D = Global.camera
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var hpMax := properties.hp
@onready var attackBox: Area2D = $Attack
@onready var attackCollision: CollisionShape2D = $Attack/AttackCollision
@onready var health: Health = $Health

# Signals
# signal __on_item_picked(item : Item)

### General Functions
func StopMovement() -> void:
	velocity.x = 0
	velocity.y = 0

func Flip() -> void:
	if velocity.x:
		sprite.flip_h = true if velocity.x < 0 else false # Flip sprite
		attackBox.scale.x = -1 if velocity.x < 0 else 1 # Flip attack collision
		
func ApplyGravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

# Animation handling
func PlayAnimation(__animName: String) -> void:
	if enterState:
		enterState = false
		if not isAttacking: # and not animationPlayer.is_playing()
			animationPlayer.play(__animName)

# State Methods (override in subclasses if needed)
func StateIdle() -> void:
	velocity.x = 0
	PlayAnimation("idle")

func StateWalk() -> void:
	PlayAnimation("walk")

func StateJump() -> void:
	if is_on_floor():
		velocity.y = -properties.jump_velocity
		PlayAnimation("jump")

func StateFall() -> void:
	PlayAnimation("fall")

func StateAttack1() -> void:
	if not isAttacking:
		isAttacking = true
		PlayAnimation("attack1")
		# Add attack behavior
		isAttacking = false

func StateAttack2() -> void:
	if not isAttacking:
		isAttacking = true
		PlayAnimation("attack2")
		# Add different attack behavior
		isAttacking = false

func StateHurt() -> void:
	# PlayAnimation("hurt")
	print("hurt")

func StateDied() -> void:
	# PlayAnimation("died")
	print("died")
	queue_free()

# Change State Method
func ChangeState(new_state: eState) -> void:
	enterState = true
	if state != new_state:
		Global.debug.DebugPrint("Changing state from " + eState.keys()[state] + " to " + eState.keys()[new_state])
		state = new_state

# Initialization
func _ready() -> void:
	health.hp_max = properties.hp
	health.hp = hpMax
	
	# Connect signals
	health.__on_damage.connect(func(_hp: float): 
		# SFX and VFX could go here
		ChangeState(eState.HURT)
	)
	health.__on_dead.connect(func(): ChangeState(eState.DIED))
	health.__on_recover.connect(func(__amount: float): 
		print("Recovered " + str(__amount) + " HP"))
	
	# Detects collision with the enemy's hitbox component
	attackBox.area_entered.connect(func(hitbox: Hitbox):
		print(hitbox.get_parent().name)
		hitbox.__take_damage(properties.strength)
	)

# Main Loop
func _physics_process(delta: float) -> void:
	match state:
		eState.IDLE: StateIdle()
		eState.WALK: StateWalk()
		eState.JUMP: StateJump()
		eState.FALL: StateFall()
		eState.ATTACK1: StateAttack1()
		eState.ATTACK2: StateAttack2()
		eState.HURT: StateHurt()
		eState.DIED: StateDied()

	ApplyGravity(delta)
	move_and_slide() # Needs to be the last function call
	
	# Clamps the player position to the camera boundaries
	# position.x = clamp(position.x, camera.position.x - CAMERA_OFFSET, camera.clamped_pos + CAMERA_OFFSET)

func _debug() -> void: pass
func _process(_delta: float) -> void: _debug()
