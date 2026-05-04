extends Camera3D

var is_dipping = false
var collect_range = 1.0

signal fish_eaten

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		position.x += event.relative.x * 0.005
		position.y -= event.relative.y * 0.005
	if event is InputEventKey and event.keycode == KEY_SPACE:
		is_dipping = event.pressed
	if event is InputEventKey and event.keycode == KEY_R:
		get_tree().quit()

func _process(delta):
	if is_dipping:
		position.z = move_toward(position.z, 0.5, 5.0 * delta)
	else:
		position.z = move_toward(position.z, 5.0, 3.0 * delta)
		
	for orb in get_tree().get_nodes_in_group("orbs"):
		if position.distance_to(orb.position) < collect_range:
			orb.queue_free()
			fish_eaten.emit()
