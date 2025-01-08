extends Control

var reactionScene: PackedScene = preload("res://scenes/ui/audience/ui_emote.tscn")

@onready var spawnArea: Sprite2D = $Crowd # The area for spawning reactions
@onready var spawnTimer: Timer = $SpawnTimer

func _ready():
	# Start the timer with a random interval between 2 and 5 seconds
	spawnTimer.start(randf_range(2.0, 5.0))

	# Connect the signal to spawn reactions periodically (did through Godot Panel)
	# spawnTimer.timeout.connect(_on_spawn_timer_timeout)

func SpawnReaction(__animation: String = "") -> void:
	# Determine the audience level if no specific animation is provided
	var level = Global.level.HUD.dramaMeter.GetAudienceLevel()
	
	# Create a new reaction instance
	var reaction = reactionScene.instantiate()
	reaction.dramaLevel = level
	add_child(reaction)

	# Get the size of the spawn area using the sprite's texture
	var areaSize = spawnArea.texture.get_size()

	# Set the reaction position randomly within the spawn area
	reaction.position = Vector2(
		randf_range(spawnArea.position.x, spawnArea.position.x + areaSize.x),
		randf_range(spawnArea.position.y, spawnArea.position.y + areaSize.y)
	)

	# Determine which animation to play
	if __animation != "":
		# Play the specific animation if provided
		reaction.PlayReaction(__animation)
	else:
		# Play the animation based on the audience level
		reaction.PlayReaction(level)

func _on_spawn_timer_timeout() -> void:
	# Randomly restart the timer with a new interval (between 2 and 5 seconds)
	spawnTimer.start(randf_range(0.5, 2.0))

	# Spawn a reaction each time the timer times out
	SpawnReaction()
