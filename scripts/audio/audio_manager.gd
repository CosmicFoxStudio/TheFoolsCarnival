class_name AudioManager extends Node

@export var musicVolume : float
@export var sfxVolume : float

@onready var musicPlayer: AudioStreamPlayer = $BackgroundMusicPlayer
@onready var menuSFXs: AudioStreamPlayer = $SFXs

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
	
	# Gets the Name of the Clip
	# Each one MUST present the naming convention "Music" at the end
	musicPlayer["parameters/switch_to_clip"] = currentMusic

func PlaySFX(playlistIndex: int) -> void:
	if menuSFXs.stream is AudioStreamPlaylist:
		var playlist = menuSFXs.stream as AudioStreamPlaylist
		
		# Check if the index is within bounds
		if playlistIndex >= 0 and playlistIndex < playlist.stream_count:
			# Access the stream from the playlist
			var selected_stream = playlist.get_list_stream(playlistIndex)
			menuSFXs.stream = selected_stream
			menuSFXs.play()
		else:
			print("Error: Invalid playlist index:", playlistIndex)
	else:
		print("Error: menuSFXs.stream is not an AudioStreamPlaylist.")
