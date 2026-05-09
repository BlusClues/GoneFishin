extends CollisionShape3D

var grab_range = 2.0
signal eaten

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	for player in get_tree().get_nodes_in_group("Player"):
		
		if global_position.distance_to(player.global_position) < grab_range:
				eaten.emit()
				print("eaten")
