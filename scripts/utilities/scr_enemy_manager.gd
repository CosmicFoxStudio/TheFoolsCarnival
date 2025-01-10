class_name EnemyManager extends Node

# OBS: This script isn't attached to any objects atm
# Instead, check obj_enemy_spawner.tscn and scr_enemy_spawner.gd

@export var enemyResources : Array[CharacterData]

enum eDifficulty { BASIC, MEDIUM, FAST }

# This is a dictionary that will hold reference to all of the Different Enemies in order to instantiate them
# cause that is the only way that you can instantiate thing. 
# By preloading or loading them
# Goddamnit Godot!

# Should be smart to move these to a Utility Reference class
var enemiesDictionary = {
	eDifficulty.BASIC : preload("res://scenes/prefab/enemies/obj_enemy_thug.tscn"),
 	eDifficulty.MEDIUM : preload("res://scenes/prefab/enemies/obj_enemy_thug.tscn") 
}

func spawn(enemy : CharacterData, pos : Vector2, rot : float) -> Enemy:
	var newEnemy = enemiesDictionary[enemy.enemyType].instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) as Enemy
	self.add_child(newEnemy)
	
	newEnemy.position = pos
	newEnemy.rotation = rot
	
	return newEnemy

# TEST ENEMY SPAWNING
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var enemy = spawn(enemyResources.pick_random(),event.position, 0)

# Refer to this dict by using a variable like 
# var objectDict := {Node: Array[Node2D]}
