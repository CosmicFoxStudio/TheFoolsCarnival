extends EnemyBase

@onready var _animation_player = $AnimationPlayer

func _ready():
	super._ready()
	enemy_type="balloon"
	score_value = 10

# Do Stuff here????????????????????
func _on_character_push(direction:Vector2, magnitude:float):
	super._on_character_push(direction, magnitude)
	_animation_player.play("charging")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "charging":
		_end_state(state_type.any)
		state_queue.enqueue(state_type.attack)
	if anim_name == "attack":
		isDead = true
