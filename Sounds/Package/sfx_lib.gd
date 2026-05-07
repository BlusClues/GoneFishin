extends Node2D

#region Instance Members
#	Set this in node inspector, preferably.
@export var sfx_root_folder = "res://assets/audio/sfx"

#	Make sure when you change these arrays in the inspector,
#	the paired name and file are at the same index.
@export var sound_names: Array[String]
@export var sound_files: Array[AudioStream]

var sfx_dict: Dictionary[String, AudioStream] = {}
#endregion

# Calls load_dictionary.
func _ready() -> void:
	if len(sound_files) == 0:
		return
	if len(sound_files) != len(sound_names):
		return
	load_dictionary()

# Takes audio folder names, passes them to load_dict_key.
func load_dictionary():
	for name in sound_names:
		sfx_dict[name] = sound_files.pop_front()

func getSFX(name:String) -> AudioStream:
	return sfx_dict[name]
