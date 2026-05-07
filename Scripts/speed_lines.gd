extends Node2D

var num_lines = 12
var radius = 200.0
var line_colour = Color.WHITE
var line_width = 2.0
var visible_lines = 0
var time_interval = 0.0
var window_width = DisplayServer.window_get_size().x
var window_height = DisplayServer.window_get_size().y
var line_list = []
var line_ages = []
var line_max_duration = 2.0
var is_dashing = false
var is_paused = false

#TODO Make speed lines not go over the fish. fish area is banned!

func _ready():
	#make list of lines that need to be added
	for i in range(num_lines):
		line_list.append(i)
		line_ages.append(0.0)
	
	#randomize order of the list
	randomize()
	line_list.shuffle()

#draw lines in a circle
func _draw():
	#get middle of the screen
	var screen_middle_x = window_width / 2 
	var screen_middle_y = window_height / 2
	
	#get the inital circle that is drawn from lines
	for i in range(visible_lines):
		#calculate the alpha of the lines dependant on age
		var alpha = 1.0 - (line_ages[i] / line_max_duration)
		var aged_line_colour = Color(line_colour, alpha)
		
		#add and calculate normal lines around the circle
		var target_slot = line_list[i]
		var angle = target_slot * 2 * PI / num_lines
		var center_pos = Vector2(screen_middle_x, screen_middle_y)
		var start_pos = Vector2(cos(angle), sin(angle)) * radius
		start_pos += center_pos
		var end_pos = Vector2(cos(angle), sin(angle)) * (radius * 2)
		
		draw_line(start_pos, end_pos + start_pos, aged_line_colour, line_width)
		
		#add and calculate a few random lines to add a bit of variation to the mix
		var new_angle = i * 2 * PI / max(1, line_list[i - 1])
		var new_start_pos = Vector2(cos(new_angle), sin(new_angle)) * radius
		new_start_pos += center_pos
		var new_end_pos = Vector2(cos(new_angle), sin(new_angle)) * (radius * 2)
		draw_line(new_start_pos, new_end_pos + new_start_pos, aged_line_colour, line_width)

func _process(delta: float):
	if !is_paused:
		if is_dashing:
			#age up the lines to add a bit of fade
			for i in range(visible_lines):
				line_ages[i] += delta
				if line_ages[i] >= line_max_duration:
					line_ages[i] = 0.0
					line_list[i] = randi_range(0, num_lines * 2)
			
			#draw lines in one by one
			time_interval += delta
			if time_interval >= 0.3:
				if visible_lines < num_lines:
					visible_lines += 1
					time_interval = 0.0

			queue_redraw()
		else:
			#make the lines gradually fade after dashing
			for i in range(visible_lines):
				line_ages[i] += delta * 2
				queue_redraw()
			while visible_lines != 0 and (line_ages[0] >= line_max_duration):
				line_list.pop_front()
				line_ages.pop_front()
				visible_lines -= 1
				line_ages.append(0.0)
				line_list.append(randi_range(0, num_lines))

#check if the player is currently dashing
func _on_player_dash_state_changed(is_player_dashing: bool):
	is_dashing = is_player_dashing

#check if the game is paused
func _on_game_over_screen_gameover_pause(is_gameover_paused: bool):
	is_paused = is_gameover_paused
