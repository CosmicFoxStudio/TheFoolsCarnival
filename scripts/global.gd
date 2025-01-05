extends Node

var main_scene : Node
var scene_transition : SceneTransition
var level : LevelController
var playerResource : CharacterData = preload("res://resources/characters/res_char_pierrot.tres")
var debug : GlobalDebug

var pause : bool = false
var debugMode : bool = true
