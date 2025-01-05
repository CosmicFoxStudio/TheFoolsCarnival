extends Node

var main_scene : Node
var scene_transition : SceneTransition
var level : LevelController
var camera : Camera2D
var playerResource : CharacterData = preload("res://resources/characters/res_char_pierrot.tres")
var HUD : UI
var debug : GlobalDebug

var pause : bool = false
var debugMode : bool = true
