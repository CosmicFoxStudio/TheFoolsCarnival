class_name Enemy extends Character

# TO-DO: Cooldown Attack Time for enemies

@export var scoreLoot := 25
@export var distanceAttack := 1.2 # The min value of targetDistance for the enemy to attack
@export var effectResource : HitEffectResource

var targetDistance : Vector2 # Distance to player
var walkTimer : float = 0
var faceRight : bool = false
var inAttack : bool = false
var hurtIndex : int = 0
var scoreValue : int = 30 # Change Later
#var SOUNDS = []

@onready var AITimer: Timer = $AITimer
@onready var hitboxCollision: CollisionShape2D = $Hitbox/HitboxCollision
@onready var enemyVoice: AudioStreamPlayer = $EnemyVoice

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
	# (FIX ME) Attack Box doesn't adapt correctly when sprite is flipped
	attackBox.scale.x = -1 if faceRight else 1

func SetHurtThrow() -> void:
	PlayAnimation("down")
	
	# Can't receive damage while downed
	hitboxCollision.disabled = true
	
	# Horizontal throw - Not working too nicely with move_and_slide() :( 
	velocity.x = 0.3 if Global.level.player.global_position.x < self.global_position.x else -0.3
	
	# Vertical throw
	velocity.y = 3
	#velocity.x = 0

# State Overrides
func StateIdle() -> void: pass
func StateWalk(delta) -> void: targetDistance = Global.level.player.position - self.position

func StateJump() -> void:
	if is_on_floor():
		velocity.y = -properties.jump_velocity
		PlayAnimation("jump")

func StateFall() -> void: pass
func StateAttack() -> void: pass
func StateAttack2() -> void: pass
func StateHurt() -> void: pass
func StateDown() -> void: pass
func StateUp() -> void: pass
func StateDied() -> void: Global.level.HUD.AddScore(scoreLoot)
