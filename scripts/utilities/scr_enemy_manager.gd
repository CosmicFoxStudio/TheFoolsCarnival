class_name EnemyManager extends Node

@export var enemyResources : Array[EnemyResource]

# This is a dictionary that will hold reference to all of the Different Enemies in order to instantiate them
# cause that is the only way that you can instantiate thing. 
# By preloading or loading them
# Goddamnit Godot!

# Should be smart to move these to a Utility Reference class
var enemiesDictionary = {
	Util.ENEMY_TYPES.BASIC : preload("res://scenes/prefab/enemies/enemy_char.tscn"),
 	Util.ENEMY_TYPES.MEDIUM : preload("res://scenes/prefab/enemies/enemy_choro.tscn") 
}

func spawn(enemy : EnemyResource, pos : Vector2, rot : float) -> EnemyBase:
	var newEnemy = enemiesDictionary[enemy.enemyType].instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as EnemyBase
	self.add_child(newEnemy)
	
	newEnemy.position = pos
	newEnemy.rotation = rot
	
	return newEnemy
	

# TEST ENEMY SPAWNINH
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var enemy = spawn(enemyResources.pick_random(),event.position, 0)
	
