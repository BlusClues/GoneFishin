extends StaticBody3D

signal dash_state_changed(is_player_dashing: bool)
signal current_button_presses(button_presses: float)
signal max_buttons_needed(max_amount_needed: float)

var dashing = false
var is_game_paused = false
var ate_lure = false
var is_gameover = false
var needed_escape_amount = 20.0
var escape_button_presses = 0.0
var just_hooked = false
var escape_timer = 200

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
			
			#dashing logic
			if dashing:
				#Not sure how intense we want the dash but this works for now
				#need to balance later!
				position.z += (-20.0 * delta) * 2
		elif ate_lure:
			escape_timer -= 1
			
			if just_hooked:
				print("Justhokkoe")
				max_buttons_needed.emit(needed_escape_amount)
				current_button_presses.emit(escape_button_presses)
				just_hooked = false
			
			#print("hooked")
			if Input.is_action_just_pressed("Escape"):
				print("Button pressed")
				escape_button_presses += 1
				current_button_presses.emit(escape_button_presses)
			
			if escape_timer <= 0:
				print("1")
				if escape_button_presses >= 0:
					print("2")
					escape_button_presses -= 1.0
					current_button_presses.emit(escape_button_presses)
					escape_timer = 200
			
			if escape_button_presses >= needed_escape_amount:
				ate_lure = false
				escape_button_presses = 0.0

	else:
		#return mouse if game is paused
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#checks if the game is paused
func _on_game_over_screen_gameover_pause(is_gameover_paused: bool):
	is_game_paused = is_gameover_paused

#checks if you ate a lure
func _on_collision_shape_3d_lure_eaten():
	just_hooked = true
	ate_lure = true



#TODO
#1 pause player and timer
#2 track the amount of button presses
#3 make graphic and progress bar come up with the amount of button presses needed\\\\\\\\
#4 make it so button presses gradually goes down to encourage mashing
#5 resume the player and timer
#6 reward the player for escaping?
