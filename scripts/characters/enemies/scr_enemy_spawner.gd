extends Area2D

enum sides { LEFT = 0, RIGHT = 1 }

@export var amount: int = 0
@export var enemies: Array[PackedScene]

func _ready() -> void:
	body_entered.connect(func(_player: Player): SpawnEnemies())

func SpawnEnemies() -> void:
	if Global.level.lastArea:
		Global.audio.musicPlayer.stop()
		# Play Boss Music
		Global.audio.musicPlayer.stream = load("res://assets/audio/music/boss_fight.mp3")
		Global.audio.musicPlayer.play()

	for i in range(amount):
		# Returns a random value between 0 and the amount of enemies
		var enemy = enemies[randi() % enemies.size()].instantiate()
		# Set random position within the current segment boundaries
		enemy.position = SetEnemyRandomPosition()
		
		# Add each enemy to the scene
		get_parent().call_deferred("add_child", enemy)

	# Update amount of enemies in Level Controller
	Global.level.ConfigNextArea(amount)

	# After the spawn is done, remove this node from the scene
	queue_free()

func SetEnemyRandomPosition() -> Vector2:
	# Retrieve the current segment's boundaries from the Line2D markers
	var screenLeft = get_parent().areaMarkers[0].get_point_position(0)  # Assuming the first Line2D is the left boundary
	var screenRight = get_parent().areaMarkers[0].get_point_position(1)  # Assuming the second Line2D is the right boundary
	var spawnY = randf_range(0.0, 260.0)  # Random Y position within height range

	var side = randi_range(sides.LEFT, sides.RIGHT)
	var spawnX: float

	match side:
		sides.LEFT:
			spawnX = randf_range(screenLeft.x - 50, screenLeft.x)  # Left outside view
		sides.RIGHT:
			spawnX = randf_range(screenRight.x, screenRight.x + 50)  # Right outside view

	return Vector2(spawnX, spawnY)
