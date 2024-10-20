extends EnemyBase

@onready var HurtTimer = $HurtTimer
@onready var DespawnTimer = $DespawnTimer
@onready var Sprite = $Sprite2D

@export var walk_speed:float

var previous_distance:float
var distance:float

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	animationPlayer = $AnimationPlayer
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

	Sprite.flip_h = target_normalized.x < 0 # Sets the direction the enemy will walk
	
	if distance <= detection_radius and current_state.type == state_type.idle: # Walk when the Player is near
		apply_force(target_normalized * walk_speed)
	else:
		apply_force(linear_velocity * -1)
	
	if(distance <= attack_trigger_radius):
		print(distance)
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
		animationPlayer.play("flying")
		DespawnTimer.start()
		gravity_scale = 0
		linear_damp = 0

func _on_despawn_timer_timeout():
	isDead = true

func _on_hurt_timer_timeout():
	_end_state(state_type.hurt)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		_end_state(state_type.attack)
	
func _on_attack_area_2d_body_entered(body):
	if body == player:
		_end_state(state_type.walk)
		state_queue.enqueue(state_type.attack)
