extends Area2D

enum sides { LEFT = 0, RIGHT = 1 }

@export var amount: int = 0
@export var enemies: Array[PackedScene]

func _ready() -> void:
	body_entered.connect(func(_player: Player): SpawnEnemies())

func SpawnEnemies() -> void:
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
	var segment = Global.level.currentSegmentIndex
	var screenLeft = get_parent().areaMarkers[segment - 1].position
	var screenRight = get_parent().areaMarkers[segment].position
	var spawnY = Global.FLOOR 
	#var spawnY = randf_range(0.0, 260.0)  # Random Y position within height range
	
	var side
	# Enemies in first segment should spawn to the right
	if Global.level.currentSegmentIndex == 0:
		print("Enemy will spawn on the right")
		side = sides.RIGHT
	# Enemy in last segment (boss) should spawn to the left
	elif Global.level.currentSegmentIndex == Global.level.areaMarkers.size() - 1: 
		print("Boss will spawn on the left")
		side = sides.LEFT
	# Other segments
	else: 
		side = randi_range(sides.LEFT, sides.RIGHT)
	
	var spawnX: float

	match side:
		sides.LEFT:
			# spawnX = screenLeft.x - 80
			spawnX = randf_range(screenLeft.x - 80, screenLeft.x)
		sides.RIGHT:
			# spawnX = screenRight.x + 80
			spawnX = randf_range(screenRight.x, screenRight.x + 80)

	return Vector2(spawnX, spawnY)
