class_name AudioManager extends Node

# Are we using these?


@onready var musicPlayer: AudioStreamPlayer = $BackgroundMusicPlayer
@onready var sfxPlayer: AudioStreamPlayer = $SFXMusicPlayer

var musicName : String  # Name of the music clip
var sfxName : String    # Name of the SFX clip
var musicPaused : bool = false
var musicVolume : float = -15
var sfxVolume : float = -10

func _ready() -> void:
	Global.audio = self

func _process(_delta: float) -> void:
	update_volume()
	_debug()

func SetMusic(tag : String) -> void:
	if(musicName != tag): 
		musicName = tag
		UpdateLevelMusic()

func SetSFX(tag: String) -> void:
	if sfxName != tag:
		sfxName = tag
		UpdateLevelSFX()

func UpdateLevelMusic():
	musicPlayer["parameters/switch_to_clip"] = musicName

func UpdateLevelSFX() -> void:
	sfxPlayer["parameters/switch_to_clip"] = sfxName

func PauseMusic() -> void:
	if musicPlayer.playing:
		musicPlayer.stop()
		musicPaused = true

func ResumeMusic() -> void:
	if musicPaused:
		musicPlayer.play()
		musicPaused = false
	else: # Reset
		UpdateLevelMusic()
		musicPlayer.play()

# (TO-DO: Convert to PascalCase (func) and camelCase (var)
func update_volume() -> void:
	var music_bus_index = AudioServer.get_bus_index("music")
	var sfx_bus_index = AudioServer.get_bus_index("sfx")
	
	AudioServer.set_bus_volume_db(music_bus_index, Global.audio.musicVolume)
	AudioServer.set_bus_volume_db(sfx_bus_index, Global.audio.sfxVolume)

func set_volume(busTag : String, volume : float) -> void:
	var audio_bus = AudioServer.get_bus_index(busTag)
	AudioServer.set_bus_volume_db(audio_bus, volume)

func _debug() -> void:
	Global.debug.UpdateDebugVariable(18, "[AUDIO] Music: " + str(musicName))
	Global.debug.UpdateDebugVariable(19, "[AUDIO] SFX: " + str(sfxName))
