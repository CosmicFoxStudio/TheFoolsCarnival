class_name AudioManager extends Node

@export var musicVolume : float
@export var sfxVolume : float

@onready var musicPlayer: AudioStreamPlayer = $BackgroundMusicPlayer
@onready var menuSFXs: AudioStreamPlayer = $SFXs

var currentMusicTag : String # Nome do Clip da Playlist

func set_music_tag(tag : String) -> void:
	if(currentMusicTag != tag): 
		currentMusicTag = tag
		UpdateLevelMusic()
		
func _ready() -> void:
	Global.audio = self

func _process(_delta: float) -> void:
	update_volume()
	if(currentMusicTag != Global.audio.currentMusicTag):
		currentMusicTag = Global.audio.currentMusicTag
		UpdateLevelMusic()

func UpdateLevelMusic():
	# var currentStageMusic = str(currentMusicTag + "Music")
	
	# Gets the Name of the Clip
	# Each one MUST present the naming convention "Music" at the end
	musicPlayer["parameters/switch_to_clip"] = currentMusicTag

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


func update_volume() -> void:
	var music_bus_index = AudioServer.get_bus_index("music")
	var sfx_bus_index = AudioServer.get_bus_index("sfx")
	
	AudioServer.set_bus_volume_db(music_bus_index, Global.audio.musicVolume)
	AudioServer.set_bus_volume_db(sfx_bus_index, Global.audio.sfxVolume)

func set_volume(busTag : String, volume : float) -> void:
	var audio_bus = AudioServer.get_bus_index(busTag)
	AudioServer.set_bus_volume_db(audio_bus, volume)
	
# The index of the Clip from the Playlist that will be played
