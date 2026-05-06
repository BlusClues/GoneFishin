extends StaticBody3D

#capture inputs
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#interpreting user inputs
func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x * 0.005
		position.y -= event.relative.y * 0.005
		
		global_position.x = clamp(global_position.x, -17.0, 17.0)
		global_position.y = clamp(global_position.y, -10.0, 10.0)
		
	if event is InputEventKey and event.keycode == KEY_R:
		get_tree().quit()
		

func _process(delta):
	#swimming
	position.z += -20.0 * delta
	
	#dash forward to eat
	#if is_dipping:
	#	position.z = move_toward(position.z, 0.5, 5.0 * delta)
	#else:
	#	position.z = move_toward(position.z, 5.0, 3.0 * delta)
	
