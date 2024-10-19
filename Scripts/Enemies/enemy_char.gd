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
var motion : Vector2

const state_type := preload("res://Scripts/state_type_enum.gd").state_type
var state_queue : StateQueue

var default_state : CharacterState
var current_state : CharacterState

var isDead := false
var x_direction := 0.0

var walkTimer := 0.0

func _ready() -> void:
	randomize()
	StateQueue.new(2)
	default_state = CharacterState.new(state_type.idle, true)
	current_state = default_state

func _process(delta: float) -> void:
	_flip()
	
func _physics_process(delta: float) -> void:
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
		
	if(distance <= (detection_radius * detection_radius)): # Walk when the Player is near
		motion = Vector2(x_direction * enemyResource.speed * 10 * delta,velocity.y)
	
	velocity = motion
	
func _is_on_ground() -> bool:
	return ground_raycast2D.is_colliding()
	
func _flip() -> void:
	if motion.x < 0: enemySprite.flip_h = true 
	elif motion.x > 0: enemySprite.flip_h = false
	
func _attack() -> void:
	pass
	
func _take_damage(amount) -> void:
	pass

func _animations() -> void:
	pass

func update_state()-> void:
	if(current_state.done):
		dequeue_state()
		
func enqueue_state(type : state_type) -> void:
	if current_state.type == type or state_queue.find(type) == -1:
		return
	
	var state = CharacterState.new(type)
	
	state_queue.append(state)


func dequeue_state() -> void:
	if(state_queue.size() == 0):
		if(current_state.type != state_type.idle):
			current_state = default_state
		return
		
	var state = state_queue.pop_front()
	if not current_state.done:
		return
		
	current_state = state
