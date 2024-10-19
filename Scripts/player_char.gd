extends CharacterBody2D

@export var max_state_queue_size:int

@export var speed = 300.0
@export var jump_velocity = -400.0

@onready var _animation_player = $AnimationPlayer
@onready var _sprite2d = $Sprite2D

const state_type = preload("res://Scripts/state_type_enum.gd").state_type

var state_queue:Array[CharacterState]
var default_state: CharacterState
var current_state:CharacterState

func _ready():
	state_queue = []
	default_state = CharacterState.new(state_type.idle, true)
	current_state = default_state

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
	
	if Input.is_action_just_pressed("basic_attack") and is_on_floor():
		end_state()
		enqueue_state(state_type.attack)
	
	if current_state.type == state_type.idle:
		_animation_player.play("idle")
	if current_state.type == state_type.walk:
		_animation_player.play("walk")
	if current_state.type == state_type.jump:
		_animation_player.play("jump")
	if current_state.type == state_type.attack:
		_animation_player.play("attack")

func reset_state():
	current_state = default_state
	state_queue.clear()

func update_state():
	if current_state.done:
		dequeue_state()
	
func enqueue_state(type:state_type):
	if current_state.type == type or find_in_queue(type) != -1:
		return

	var state = CharacterState.new(type)

	state_queue.append(state)

func dequeue_state():
	if state_queue.size() == 0:
		if current_state.type != state_type.idle:
			current_state = default_state
		return

	var state = state_queue.pop_front()

	if not current_state.done:
		return

	current_state = state

func find_in_queue(type:state_type):
	var index = -1

	for i in range(state_queue.size()):
		var character_state = state_queue[i]
		if character_state.type == type:
			index = i
			break

	return index

func end_state(type:state_type = state_type.any):
	if current_state.type == type or type == state_type.any:
		current_state.done = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		end_state(state_type.attack)
