extends Node3D

@onready var FishEatingGood: AudioStreamPlayer3D = $"res://Sounds/FishEatingGood.wav"
@onready var FishHookedGood: AudioStreamPlayer3D = $"res://Sounds/FishHookedGood.wav"
@onready var LineSnap: AudioStreamPlayer3D = $"res://Sounds/LineSnap.wav"
@onready var Reeling: AudioStreamPlayer3D = $"res://Sounds/Reeling.wav"
@onready var WaterSplash: AudioStreamPlayer3D = $"res://Sounds/WaterSplashh.wav"
@onready var DashRiverAMB: AudioStreamPlayer3D = $"res://Sounds/DashRiverAMB.wav"

class: class AudioManager()
	func RiverDashAMB():
		## Call the play() method on the reference
		#FishEatingGood.play() 
		#FishHookedGood.play()
		#LineSnap.play()
		#Reeling.play()
		#WaterSplash.play()
		DashRiverAMB.play()
	
