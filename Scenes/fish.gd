extends Node3D

@onready var fish1 = $"Area3D/Scomber scrombus"
@onready var fish2 = $"Area3D/Luciobarbus guiranois"
@onready var fish3 = $"Area3D/Lithognathus mormyrus"
@onready var fish4 = $Area3D/Lichia_amia
@onready var fish5 = $Area3D/Diplodus_Sargus
@onready var fish6 = $Area3D/Dicentrarchus_labrax
@onready var fish7 = $Area3D/Coryphaena_hippurus
@onready var fish8 = $Area3D/Cobitis_paludica
@onready var fish9 = $Area3D/Seriola_dumerili
@onready var fish_list = [fish1, fish2, fish3, fish4, fish5, fish6, fish7, fish8, fish9]

func _ready():
	var fish_model = fish_list[randi_range(0, fish_list.size() - 1)]
	
	fish_model.visible = true
