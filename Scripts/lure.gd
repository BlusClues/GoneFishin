extends Node3D

@onready var lure1 = $Area3D/Lure_1
@onready var lure2 = $Area3D/Lure_2
@onready var lure_list = [lure1, lure2]

#randomly pick a sprite to make visible from the list
func _ready():
	var lure_model = lure_list[randi_range(0, lure_list.size() - 1)]
	lure_model.visible = true

func _process(delta):
	#swimming
	var speed = -10
	position.z += speed * delta
