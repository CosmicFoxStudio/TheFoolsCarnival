extends Node

# Const
const SCREEN_WIDTH : float = 640.0
const SCREEN_HEIGHT : float = 360.0
const FLOOR : float = 327.0

# Preloads
var playerResource : CharacterData = preload("res://resources/characters/res_char_pierrot.tres")

# Global Objects
# Refer to them as: (e.g.: Global.debug, Global.sceneTransition.transition(...), Global.level.player, etc)
var mainScene : Node
var sceneTransition : SceneTransition
var level : LevelController
var debug : GlobalDebug
var audio : AudioManager
var effects : EffectManager
var settings : Settings
var playerHitCount: int = 0

# Global Variables
var pause : bool = false
var debugMode : bool = true
