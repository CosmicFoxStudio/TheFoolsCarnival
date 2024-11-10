class_name EnemyBase extends RigidBody2D

signal enemy_dead(enemy: EnemyBase)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null
@onready var ground_raycast2D: RayCast2D = $RayCast2D if has_node("RayCast2D") else null
@onready var player : CharacterBody2D = get_tree().current_scene.get_node("Player")

const state_type := preload("res://scripts/characters/state_type_enum.gd").state_type

var state_queue : StateQueue
var default_state : CharacterState
var previous_state: CharacterState
var current_state : CharacterState

var motion : Vector2
var x_direction := 0.0
var walkTimer := 0.0
var health : float
var damage : float
var score_value: int
var enemy_type: String
var isDead := false

@export var detection_radius := 10
@export var attack_trigger_radius := 1.0
@export var attack_area : AttackArea2D
@export var enemyResource : EnemyResource

func _set_enemyResource(res: EnemyResource): 
	enemyResource = res
func _ready() -> void:
	state_queue = StateQueue.new(3)
	default_state = CharacterState.new(state_type.idle, true)
	current_state = default_state

func _process(_delta: float) -> void:
	update_state()
	_animations()
	_flip()
	
func _physics_process(_delta: float) -> void:
	_movement(_delta)
	
func _movement(_delta) -> void:
	if isDead:
		emit_signal("enemy_dead", self)
		queue_free()
		return
	
	
func _is_on_ground() -> bool:
	return ground_raycast2D.is_colliding()
	
func _flip() -> void:
	if motion.x < 0: animated_sprite.flip_h = true
	elif motion.x > 0: animated_sprite.flip_h = false
	
func _attack() -> void:
	attack_area.set_attack_damage(enemyResource.damage)
	
func _take_damage(amount) -> void:
	if(health <= 0):
		return
		
	health -= amount
	if(health <= 0):
		isDead = true
		#enqueue_state() # dead state
	
func _on_character_push(direction:Vector2, magnitude:float):
	apply_force(direction.normalized() * magnitude)

func _animations() -> void:
	if animated_sprite:
		# Use AnimatedSprite2D animations if available
		if state_just_entered(state_type.idle):
			animated_sprite.play("idle")
		if state_just_entered(state_type.walk):
			animated_sprite.play("walk")
		if state_just_entered(state_type.attack):
			animated_sprite.play("attack")
		if state_just_entered(state_type.hurt):
			animated_sprite.play("hurt")
	elif animation_player:
		# Use AnimationPlayer animations if available
		if state_just_entered(state_type.idle):
			animation_player.play("idle")
		if state_just_entered(state_type.walk):
			animation_player.play("walk")
		if state_just_entered(state_type.attack):
			animation_player.play("attack")
		if state_just_entered(state_type.hurt):
			animation_player.play("hurt")

func update_state():
	previous_state = current_state
	if current_state.done and not is_idle():
		current_state = state_queue.dequeue()
		
func enqueue_state(type:state_type):
	if current_state.type == type:
		return
		
	return state_queue.enqueue(type)

func _end_state(type: state_type) -> void:
	if current_state.type == type or type == state_type.any:
		current_state.done = true
		
func state_just_entered(type:state_type):
	return current_state.type == type && previous_state.type != type

func is_idle():
	if state_queue.queue.size() == 0:
		if current_state.type != state_type.idle:
			current_state = default_state
		return true

	return false
