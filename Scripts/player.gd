extends StaticBody3D

signal dash_state_changed(is_player_dashing: bool)

signal RiverDashAMB (name)


var dashing = false
var is_game_paused = false
var ate_lure = false
var is_gameover = false
var needed_escape_amount = 20
var escape_button_presses = 0

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
		if !ate_lure:
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
				emit_signal("RiverDashAMB", "RiverDashAMB")
			
			#dashing logic
			if dashing:
				#Not sure how intense we want the dash but this works for now
				#need to balance later!
				position.z += (-20.0 * delta) * 2
		elif ate_lure:
			#print("hooked")
			if Input.is_action_just_pressed("Escape"):
				print("Button pressed")
				escape_button_presses += 1
			
			if escape_button_presses >= needed_escape_amount:
				ate_lure = false
	else:
		#return mouse if game is paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#checks if the game is paused
func _on_game_over_screen_gameover_pause(is_gameover_paused: bool):
	is_game_paused = is_gameover_paused

#checks if you ate a lure
func _on_collision_shape_3d_lure_eaten():
	ate_lure = true


#TODO
#1 pause player and timer
#2 track the amount of button presses
#3 make graphic and progress bar come up with the amount of button presses needed
#4 make it so button presses gradually goes down to encourage mashing
#5 resume the player and timer
#6 reward the player for escaping?
