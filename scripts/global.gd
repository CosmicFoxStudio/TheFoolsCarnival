extends Node

# Preloads
var playerResource : CharacterData = preload("res://resources/characters/res_char_pierrot.tres")

# Global Objects
# Refer to them as: (e.g.: Global.debug, Global.sceneTransition.transition(...), Global.level.player, etc)
var mainScene : Node
var sceneTransition : SceneTransition
var level : LevelController
var debug : GlobalDebug
var audio : AudioManager
var HUD : UI
var effects : EffectManager

# Global Variables
var pause : bool = false
var debugMode : bool = true
