extends StaticBody3D

signal dash_state_changed(is_player_dashing: bool)
signal current_button_presses(button_presses: float)
signal max_buttons_needed(max_amount_needed: float)

var dashing = false
var is_game_paused = false
var ate_lure = false
var is_gameover = false
var escape_button_presses = 0.0
var just_hooked = false  
var escape_timer

const NEEDED_ESCAPE_AMOUNT = 20.0
const ESCAPE_TIMER_DEFAULT = 0.5

#capture inputs
func _ready():
	escape_timer = ESCAPE_TIMER_DEFAULT
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
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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
			#timer for the fight back with mashing
			escape_timer -= delta
			
			#send the info to the timer when first hooked
			if just_hooked:
				max_buttons_needed.emit(NEEDED_ESCAPE_AMOUNT)
				current_button_presses.emit(escape_button_presses)
				just_hooked = false
			
			#mashing function, checks if you clicked the mashing enough
			if Input.is_action_just_pressed("Escape"):
				print("Button pressed")
				escape_button_presses += 1
				current_button_presses.emit(escape_button_presses)
			
			#adds a fight back mechanic that reverses some button presses
			#this encourages the player to mash
			if escape_timer <= 0.0:
				if escape_button_presses >= 0:
					escape_button_presses -= 1
					current_button_presses.emit(escape_button_presses)
					escape_timer = ESCAPE_TIMER_DEFAULT
			
			#what happens when the player escapes/ presses required amount
			if escape_button_presses >= NEEDED_ESCAPE_AMOUNT:
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

#checks if you are in the buff choosing state
func _on_buff_cards_buff_pause(is_paused: bool):
	is_game_paused = is_paused
