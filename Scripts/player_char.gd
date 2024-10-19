extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var _animation_player = $AnimationPlayer
@onready var _sprite2d = $Sprite2D

enum states {walk, idle, jump, attack}
var state = states.idle 

func _physics_process(delta):
	if is_on_floor() and velocity.x == 0 and velocity.y == 0:
		state = states.idle
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0 && velocity.x < 0:
			_sprite2d.flip_h = true
		else:
			_sprite2d.flip_h = false
			
		if is_on_floor() and velocity.x and state != states.walk:
			state = states.walk
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if state != states.jump:
			state = states.jump

	move_and_slide()

func _process(delta):
	if state == states.idle:
		_animation_player.play("idle")
	if state == states.walk:
		_animation_player.play("walk")
	if state == states.jump:
		_animation_player.play("jump")
	

func _on_started_walking(extra_arg_0):
	pass # Replace with function body.
