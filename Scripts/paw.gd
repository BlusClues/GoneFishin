extends Node3D

var speed: float = 15.0
var going_down: bool = true


func _process(delta) -> void:
	if going_down:
		global_position.y -= speed * delta
		if global_position.y <= 5.778:
			going_down = false
	else:
		global_position.y += speed * delta
		if global_position.y >= 30:
			queue_free()
