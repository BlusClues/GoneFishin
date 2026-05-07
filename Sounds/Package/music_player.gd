extends AudioStreamPlayer2D

#region Instance Members
#	Change using node inspector.
@export var DEFAULT_TRACK = ResourceLoader.load("res://Sound Shit/Flashlight on & off (Clean).mp3")
#endregion

func _ready() -> void:
	set_stream(DEFAULT_TRACK)

#	Starts currently loaded track at start.
func start():
	play(0)

#	Starts currently loaded track at a position in the track.
func startAt(from_pos:float):
	play(from_pos)

func setTrack(track:String):
	if(playing):
		await fade_track()
		volume_db = 0
	set_stream(ResourceLoader.load(track))

func fade_track():
	var tween = get_tree().create_tween()
	tween.tween_property($Music_Player, "volume_db", -80, 1.0)
