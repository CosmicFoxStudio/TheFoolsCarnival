extends EnemyBase

@onready var HurtTimer = $HurtTimer
@onready var DespawnTimer = $DespawnTimer

@export var walk_speed:float

var previous_distance:float
var distance:float

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	score_value = 20
	enemy_type = "choro"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	

func _movement(delta) -> void:
	super._movement(delta)
	
	var target = (player.transform.origin - transform.origin)
	var target_normalized = target.normalized()
	distance = sqrt(target.length())

	animated_sprite.flip_h = target_normalized.x < 0 # Sets the direction the enemy will walk
	
	if distance <= detection_radius and current_state.type == state_type.idle:
		state_queue.enqueue(state_type.walk)
		_end_state(state_type.idle) # Walk when the Player is near
		
	if current_state.type == state_type.walk:
		apply_force(target_normalized * walk_speed)
	elif current_state.type == state_type.attack:
		apply_force(linear_velocity * -1)
	
	if(distance <= attack_trigger_radius):
		_end_state(state_type.any)
		state_queue.enqueue(state_type.attack)

func _on_character_push(direction:Vector2, magnitude:float):
	if not DespawnTimer.is_stopped():
		super._on_character_push(direction, 400)
	else:
		super._on_character_push(direction, magnitude)
	
	_end_state(state_type.any)
	state_queue.enqueue(state_type.hurt)
	HurtTimer.stop()
	HurtTimer.start()
	if magnitude >= 500:
		HurtTimer.stop()
		animated_sprite.play("rotate")
		DespawnTimer.start()
		gravity_scale = 0
		linear_damp = 0

func _on_despawn_timer_timeout():
	isDead = true

func _on_hurt_timer_timeout():
	_end_state(state_type.hurt)

#func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "grow":
		#_end_state(state_type.attack)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "hurt":
		_end_state(state_type.attack)

func _on_attack_area_2d_body_entered(body):
	if body == player:
		_end_state(state_type.walk)
		state_queue.enqueue(state_type.attack)
