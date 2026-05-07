extends StaticBody3D

signal dash_state_changed(is_player_dashing: bool)

var dashing = false
var is_game_paused = false

#capture inputs
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#interpreting user inputs
func _input(event):
	if !is_game_paused:
		if event is InputEventMouseMotion:
			position.x += event.relative.x * 0.005
			position.y -= event.relative.y * 0.005
			
			global_position.x = clamp(global_position.x, -17.0, 17.0)
			global_position.y = clamp(global_position.y, -10.0, 10.0)
			
		if event is InputEventKey and event.keycode == KEY_R:
			get_tree().quit()

func _process(delta):
	if !is_game_paused:
		#swimming
		position.z += -20.0 * delta
		
		if global_position.z < -70:
			global_position.z = 200
		
		#dashing
		var currently_dashing = Input.is_action_pressed("Dash")

		#check if your current state matches saved state
		if currently_dashing != dashing:
			dashing = currently_dashing
			dash_state_changed.emit(dashing)
		
		#dashing logic
		if dashing:
			#Not sure how intense we want the dash but this works for now
			#need to balance later!
			position.z += (-20.0 * delta) * 2
			
	else:
		#return mouse if game is paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#checks if the game is paused
func _on_game_over_screen_gameover_pause(is_gameover_paused: bool):
	is_game_paused = is_gameover_paused
