extends CollisionShape3D

var collect_range = 2.0
signal fish_eaten
signal lure_eaten

# Called every frame
func _process(delta: float) -> void:
	#when you eat an object emit signal and delete object
	for orb in get_tree().get_nodes_in_group("orbs"):
		
		if global_position.distance_to(orb.global_position) < collect_range:
			if orb in get_tree().get_nodes_in_group("fish"):
				fish_eaten.emit()
				orb.queue_free()
			elif orb in get_tree().get_nodes_in_group("lure"):
				lure_eaten.emit()
				orb.queue_free() 
				
