extends MeshInstance3D

#moving water
func _process(delta: float) -> void:
	get_active_material(0).uv1_offset.x += delta * 0.05
	get_active_material(0).uv1_offset.y += delta * 0.02
