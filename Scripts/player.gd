extends StaticBody3D

signal dash_state_changed(is_player_dashing: bool)

var dashing = false

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
	
	#dashing
	var currently_dashing = Input.is_action_pressed("Dash")
	
	#check if youro current state matches saved state
	if currently_dashing != dashing:
		dashing = currently_dashing
		dash_state_changed.emit(dashing)
	
	#dashing logic
	if dashing == true:
		#Not sure how intense we want the dash but this works for now
		#need to balance later!
		position.z += (-20.0 * delta) * 2
		pass
