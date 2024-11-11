extends CharacterBody2D

# signal lower_approval(value: int)

@export var max_state_queue_size:int
@export var combo_anims:Array[String]

@export var director_node:Director

@export var speed = 300.0
@export var jump_velocity = -400.0

@onready var _animation_player:AnimationPlayer = $AnimationPlayer
@onready var _sprite2d:Sprite2D = $Sprite2D
@onready var _attack_collision:Area2D = $AttackCollision

const state_type = preload("res://scripts-rename/characters/state_type_enum.gd").state_type

var state_queue:StateQueue
var default_state: CharacterState
var current_state:CharacterState
var previous_state: CharacterState

var combo_queue:Array[String]
var combo_index:int
var previous_combo_index:int

func _ready():
	state_queue = StateQueue.new(max_state_queue_size)
	default_state = CharacterState.new(state_type.idle, true)
	current_state = default_state
	combo_index = -1
	previous_combo_index = -1
	for body in director_node.instances:
		add_collision_exception_with(body)
		if(body.get_collision_layer_value(2)):
			# var enemy:EnemyBase = body as EnemyBase
			# var delta = body.position - position
			_attack_collision.connect("body_entered", _on_hit_enemy)
			# INCOMPLETE STUFF

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and current_state.type != state_type.attack:
		velocity.x = direction * speed
		if direction < 0 && velocity.x < 0:
			_sprite2d.flip_h = true
		else:
			_sprite2d.flip_h = false

		if is_on_floor() and velocity.x:
			enqueue_state(state_type.walk)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if not velocity.x:
			end_state(state_type.walk)
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		end_state()
		enqueue_state(state_type.jump)
	elif is_on_floor():
		end_state(state_type.jump)
	
	move_and_slide()

func _process(_delta):
	update_state()
	
	handle_attack_input()
	
	if state_just_entered(state_type.idle):
		_animation_player.play("idle")
	if state_just_entered(state_type.walk):
		_animation_player.play("walk")
	if state_just_entered(state_type.jump):
		_animation_player.play("jump")
	if state_just_entered(state_type.attack):
		combo_index = 0
		_animation_player.play(combo_anims[combo_index])

func update_state():
	previous_state = current_state
	if current_state.done and not is_idle():
		current_state = state_queue.dequeue()
	
func enqueue_state(type:state_type):
	if current_state.type == type:
		return

	return state_queue.enqueue(type)

func end_state(type:state_type = state_type.any):
	if current_state.type == type or type == state_type.any:
		current_state.done = true

func is_idle():
	if state_queue.queue.size() == 0:
		if current_state.type != state_type.idle:
			current_state = default_state
		return true

	return false

func state_just_entered(type:state_type):
	return current_state.type == type && previous_state.type != type
	
func _on_animation_player_animation_finished(anim_name:StringName):
	if combo_anims.find(anim_name) != -1:
		previous_combo_index = combo_index
		if combo_queue.size() > 0:
			_animation_player.play(combo_queue.pop_front())
		else:
			end_state(state_type.attack)
			combo_index = -1
			previous_combo_index = -1

func handle_attack_input():	
	if Input.is_action_just_pressed("basic_attack") and is_on_floor():
		if current_state.type == state_type.attack:
			if combo_index < combo_anims.size() -1:
				combo_index += 1
				combo_queue.append(combo_anims[combo_index])
			return
		
		end_state()
		enqueue_state(state_type.attack)
	
func take_damage():
	emit_signal("lower_approval", 1)
	
func _on_hit_enemy(body:Node2D):
	var enemy = body as EnemyBase
	if enemy.enemy_type == "choro" and _animation_player.current_animation != "strong_attack":
		enemy._on_character_push((body.position - position).normalized(), 0)
		return
	enemy._on_character_push((body.position - position).normalized(), 800)
	
