extends Node2D

var num_lines = 12
var radius = 100.0
var line_colour = Color.WHITE
var line_width = 2.0
#var window_size = DisplayServer.window_get_size()
var window_width = DisplayServer.window_get_size().x
var window_height = DisplayServer.window_get_size().y

#draw lines in a circle
func _draw():
	#get middle of the screen
	var screen_middle_x = window_width / 2 
	var screen_middle_y = window_height / 2
	
	#draw_circle(Vector2(screen_middle_x, screen_middle_y), 50.0, Color.RED)
	
	#get the inital circle that is drawn from lines
	for i in range(num_lines):
		var angle = i * 2 * PI / num_lines
		var start_pos = Vector2(screen_middle_x, screen_middle_y)
		var end_pos = Vector2(cos(angle), sin(angle)) * radius
		
		#math to find better positions for lines
		
		draw_line(start_pos, end_pos + start_pos, line_colour, line_width)

func _process(delta: float) -> void:
	print(window_height)
