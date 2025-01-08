class_name AudioManager extends Node

@export var bgMusicStage : AudioStreamPlayer
@export var menuSFXs : AudioStreamPlayer

@export var musicVolume : float
@export var sfxVolume : float

@onready var musicPlayer: AudioStreamPlayer = $BackgroundMusicPlayer

var currentStage : LevelController
var currentStageName : String
var currentMusic : String

func _ready() -> void:
	Global.audio = self

func _process(_delta: float) -> void:
	if(currentStageName != Global.audio.currentStageName):
		currentStageName = Global.audio.currentStageName
		UpdateLevelMusic()

func UpdateLevelMusic():
	# var currentStageMusic = str(currentStageName + "Music") 
	# Gets the Name of the Clip, each one MUST present the naming convention "Music" at the end
	bgMusicStage["parameters/switch_to_clip"] = currentMusic

# The index of the Clip from the Playlist that will be played
func PlaySFX(playlistIndex : int):
	print("streams/stream_" + str(playlistIndex))
	menuSFXs["streams/stream_" + str(playlistIndex)].play()
