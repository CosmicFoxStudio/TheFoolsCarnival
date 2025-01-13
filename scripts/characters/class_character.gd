class_name Character extends CharacterBody2D

enum eState { IDLE, WALK, JUMP, FALL, ATTACK, HURT, DOWN, UP, DIED }
enum eType { PLAYER, ENEMY, NPC }

# Signals
# signal __on_item_picked(item : Item)

# Shared properties
@export var properties: CharacterData

# Variables
var type : eType
var state : eState = eState.IDLE
var enterState: bool = true
var currentHealth: int
var isAttacking: bool = false
var dead : bool = false
#var comboAnims: Array[String] = ["attack1", "attack2"]
var comboIndex: int = 0  # The current attack in the combo

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var hpMax := properties.hpMax
@onready var attackBox: Area2D = $Attack
@onready var attackCollision: CollisionShape2D = $Attack/AttackCollision
#@onready var hitbox: Hitbox = $Hitbox
#@onready var hitbox_collision: CollisionShape2D = $Hitbox/HitboxCollision
@onready var health: Health = $Health
@onready var comboTimer: Timer = $ComboTimer # Timer to reset combo after a delay

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
	animationPlayer.play(__animName)

# State Methods (overridable in subclasses)
func StateIdle() -> void: pass
func StateWalk(_delta) -> void: pass
func StateJump(_delta) -> void: pass
func StateFall(_delta) -> void: pass
func StateAttack() -> void: pass
func StateHurt() -> void: pass
func StateDied() -> void: queue_free()

# Change State Method
func ChangeState(new_state: eState) -> void:
	if state != new_state:
		state = new_state
		enterState = true
		# DEBUG
		# Global.debug.DebugPrint("Changing state from " + eState.keys()[state] + " to " + eState.keys()[new_state])

# Attack Functions
func StartAttackCollision() -> void:
	if not isAttacking:
		attackCollision.disabled = false

func EndAttackCollision() -> void:
	if isAttacking:
		attackCollision.disabled = true

# Reset the combo chain
func ResetCombo() -> void:
	comboIndex = 0
	isAttacking = false
	ChangeState(eState.IDLE)

# This function is different for each enemy, based on the amount of hurt states
func OnDamage(__hp: float) -> void: pass

# Sound
func PlaySound(__soundTag : String) -> void: 
	pass
	#audio_stream_player.stream = sound
	#audio_stream_player.play()
	
# Initialization
func _ready() -> void:
	health.hp_max = properties.hpMax
	health.hp = hpMax
	
	### Connect signals
	# This one is mostly used by enemies, but I'll leave it here for now
	health.__on_damage.connect(func(_hp: float): 
		OnDamage(_hp)
		# SFX and VFX could go here
		ChangeState(eState.HURT)
	)
	
	health.__on_dead.connect(func(): 
		if type == eType.ENEMY: 
			# Add "Heart Reaction" to the audience
			Global.level.HUD.audience.SpawnReaction("Heart")
		ChangeState(eState.DIED)
	)
		
	health.__on_recover.connect(func(__amount: float): 
		print("Recovered " + str(__amount) + " HP"))
	
	# Detects collision with the enemy's hitbox component
	attackBox.area_entered.connect(func(__hitbox: Hitbox):
		Global.debug.DebugPrint("Hitting on: " + str(__hitbox.get_parent().name))
		__hitbox.TakeDamage(properties.strength)
	)
	
	# Update HUD
	# Global.level.HUD.HudUpdateHealth(properties.hpMax)

# Main Loop
func _physics_process(delta: float) -> void:
	match state:
		eState.IDLE: StateIdle()
		eState.WALK: StateWalk(delta)
		eState.JUMP: StateJump(delta)
		eState.FALL: StateFall(delta)
		eState.ATTACK: StateAttack()
		eState.HURT: StateHurt()
		eState.DIED: StateDied()

	ApplyGravity(delta)
	move_and_slide() # Needs to be the last function call

func _debug() -> void: pass
func _process(_delta: float) -> void: _debug()
