extends Node3D

@onready var lib = $SFX_Lib
@onready var musicPlayer = $Music_Player

func _ready() -> void:
	playSoundTrack()

func playSound(key: String):# Pass sound_key.
	# Setup for new ASP2D node.
	# Retrieve sound from argument key.
	var sfx = AudioStreamPlayer3D.new()
	var tempSFX = lib.getSFX(key)
	# Setting up properties.
	sfx.set_stream(tempSFX)
	sfx.set_autoplay(true)
	sfx.set_bus("SFX")
	
	add_child(sfx)# Instantiate streamplayer with stream as sound.
	
	await get_tree().create_timer(tempSFX.get_length()).timeout
	# Thinking await might cause an issue when more than
	# sound needs to load in quick succession. Will it completely
	# halt the funct flow?
	
	sfx.queue_free()
# Kills instance.

#region Music Player Helper Functions
#	Plays music at start of stream.
func playSoundTrack():
	musicPlayer.start()

#	Plays music at 'time' as position in stream.
func playSoundTrackAt(time:float):
	musicPlayer.startAt(time)

#	Change music player audio track,
#	includes fade logic.
func changeTrack(name:String):
	musicPlayer.setTrack(name)
#endregion


func RiverDashAMB(name: Variant) -> void:
	playSound(name)
