extends Area2D

enum sides { LEFT = 0, RIGHT = 1 }

@export var unlockedAtArea: float
@export var amount: int = 0
@export var enemies: Array[PackedScene]
@export var lastArea: bool = false

@onready var camera: Camera2D = Global.level.camera

func _ready() -> void:
	# Connect signal to activate the functions when player collides
	body_entered.connect(func(_player: Player): SpawnEnemies())

func SpawnEnemies() -> void:
	if lastArea:
		var levelMusic = get_parent().get_node("AudioStreamPlayer")
		levelMusic.stop()

		# Play Boss Music
		levelMusic.stream = load("res://assets/audio/music/boss_fight.mp3")
		levelMusic.play()

	for i in amount:
		# Returns a random value between 0 and the amount of enemies
		var enemy = enemies[randi() % enemies.size()].instantiate()
		# Takes a random position
		enemy.position = SetEnemyRandomPosition()
		
		# Add each enemy to the scene
		# call_deffered() ensures enemies are added safely during the physics processing phase
		get_parent().call_deferred("add_child", enemy)

	Global.level.ConfigNextArea(amount, unlockedAtArea)
	if lastArea: Global.level.lastArea = true
	# After the spawn is done, remove this node from the scene
	queue_free()

func SetEnemyRandomPosition() -> Vector2:
	# Determine the screen bounds relative to the camera
	var screenLeft = camera.position.x # Screen width divided by 2
	var screenRight = camera.position.x
	var spawnY = randf_range(0.0, 360.0) # Random Y position within map height

	var side = randi_range(sides.LEFT, sides.RIGHT)
	var spawnX: float

	match side:
		sides.LEFT:
			spawnX = randf_range(screenLeft - 50, screenLeft)  # Left outside view
		sides.RIGHT:
			spawnX = randf_range(screenRight, screenRight + 50)  # Right outside view

	return Vector2(spawnX, spawnY)
