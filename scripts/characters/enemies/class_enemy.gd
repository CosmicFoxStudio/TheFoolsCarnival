class_name Enemy extends Character

# TO-DO: Cooldown Attack Time for enemies

@export var distanceAttack := 1.2

var walkTimer : float = 0
var faceRight : bool = false
var inAttack : bool = false
var hurtIndex : int = 0
#var SOUNDS = []

@onready var AITimer: Timer = $AITimer
@onready var enemyVoice: AudioStreamPlayer = $EnemyVoice

# Custom logic to decide AI attack behavior
#func ContinueCombo() -> bool:
	#return randi() % 2 == 0  # 50% chance to continue combo

# Initialization
func _ready() -> void:
	super()
	type = eType.ENEMY

# Parent Class Overrides
func Flip() -> void: 
	# Check player direction
	faceRight = Global.level.player.transform.origin.x > self.transform.origin.x
	
	# Flip sprite
	sprite.flip_h = faceRight

	# Flip attack collision based on facing direction
	attackBox.scale.x = -1 if faceRight else 1

# State Overrides
func StateIdle() -> void: pass
func StateWalk(_delta) -> void: pass

func StateJump() -> void:
	if is_on_floor():
		velocity.y = -properties.jump_velocity
		PlayAnimation("jump")

func StateFall() -> void: pass
func StateAttack() -> void: pass #HandleAttack(0)
func StateAttack2() -> void: pass #HandleAttack(1)

# This function is different for each enemy, based on the amount of hurt states
func OnDamage(__hp: float) -> void: pass
