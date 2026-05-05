extends Camera3D

var is_dipping = false
var collect_range = 1.0

signal fish_eaten
signal lure_eaten

#capture inputs
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#interpreting user inputs
func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x * 0.005
		position.y -= event.relative.y * 0.005
	if event is InputEventKey and event.keycode == KEY_SPACE:
		is_dipping = event.pressed
	if event is InputEventKey and event.keycode == KEY_R:
		get_tree().quit()

func _process(delta):
	#dash forward to eat
	if is_dipping:
		position.z = move_toward(position.z, 0.5, 5.0 * delta)
	else:
		position.z = move_toward(position.z, 5.0, 3.0 * delta)
	
	#when you eat an object emit signal and delete object
	for orb in get_tree().get_nodes_in_group("orbs"):
		if position.distance_to(orb.position) < collect_range:
			if orb in get_tree().get_nodes_in_group("fish"):
				fish_eaten.emit()
				orb.queue_free()
			elif orb in get_tree().get_nodes_in_group("lure"):
				lure_eaten.emit()
