extends CharacterBody2D

class_name EnemyBase

@export var enemyResource : EnemyResource
func _set_enemyResource(res:EnemyResource): 
	enemyResource = res

@export var animationPlayer : AnimationPlayer

@onready var ground_raycast2D: RayCast2D = $RayCast2D
@onready var enemySprite: Sprite2D = $Sprite2D
@onready var player : CharacterBody2D = get_parent().get_node("Player")

@export var detection_radius := 4.0
@export var attack_trigger_radius := 1.0

@export var attack_area : AttackArea2D


var motion : Vector2

const state_type := preload("res://Scripts/state_type_enum.gd").state_type
var state_queue : StateQueue

var default_state : CharacterState
var current_state : CharacterState

var health : float
var damage : float

var isDead := false

var x_direction := 0.0

var walkTimer := 0.0

func _ready() -> void:
	state_queue = StateQueue.new(3)
	default_state = CharacterState.new(state_type.idle, true)
	current_state = default_state

func _process(delta: float) -> void:
	_animations()
	_flip()
	
func _physics_process(delta: float) -> void:
	update_state()
	_movement(delta)
	move_and_slide()
	
func _movement(delta) -> void:
	if isDead:
		print("Enemy is dead")
		return
	
	if not _is_on_ground():
		velocity += get_gravity() * delta
		
	var target = (player.transform.origin - transform.origin);
	var target_normalized = target.normalized()
	
	var distance = sqrt(target.length())
	
	x_direction = target_normalized.x; # Sets the direction the enemy will walk

	walkTimer += delta
	if(walkTimer > randi_range(2,5)):
		walkTimer = 0
		
	if(distance <= detection_radius * detection_radius): # Walk when the Player is near
		motion = Vector2(x_direction * enemyResource.speed * 10 * delta,velocity.y)
		enqueue_state(state_type.walk)
		
	if(distance <= attack_trigger_radius * attack_trigger_radius):
		motion = Vector2(0.1 * delta,velocity.y)
		enqueue_state(state_type.attack)
	
	velocity = motion
	
	
func _is_on_ground() -> bool:
	return ground_raycast2D.is_colliding()
	
func _flip() -> void:
	if motion.x < 0: enemySprite.flip_h = true 
	elif motion.x > 0: enemySprite.flip_h = false
	
func _attack() -> void:
	attack_area.set_attack_damage(enemyResource.damage)
	
func _take_damage(amount) -> void:
	if(health <= 0):
		return
		
	health -= amount
	if(health <= 0):
		isDead = true
		#enqueue_state() # dead state
	pass

func _animations() -> void:
	
	
	if current_state.type == state_type.idle:
		animationPlayer.play("idle")
	if current_state.type == state_type.walk:
		animationPlayer.play("walk")
	if current_state.type == state_type.attack:
		animationPlayer.play("attack")
	

func update_state():
	if current_state.done and not is_idle():
		current_state = state_queue.dequeue()
		
func enqueue_state(type:state_type):
	if current_state.type == type:
		return
		
	return state_queue.enqueue(type)

func _end_state(type: state_type) -> void:
	if current_state.type == type or type == state_type.any:
		current_state.done = true


func is_idle():
	if state_queue.queue.size() == 0:
		if current_state.type != state_type.idle:
			current_state = default_state
		return true

	return false
