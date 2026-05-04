extends Node2D

@onready var hunger_bar = $CanvasLayer/Panel/HungerBar
@onready var eaten_label = $CanvasLayer/Panel/EatenLabel
@onready var timer = $Timer

var hunger_time = 10

func _ready():
	#set the eaten label to invisible
	eaten_label.modulate.a = 0.0
	
	#initalize the progress bar
	hunger_bar.value = hunger_time
	hunger_bar.max_value = hunger_time
	
	#start timer
	timer.wait_time = hunger_time
	timer.start()

#make hunger tick down
func _process(delta):
	hunger_bar.value = timer.time_left

#when timer stops
func _on_timer_timeout():
	print("Timer Stop")

#when you eat a fish add time to timer
#signal from camera_3d
func _on_camera_3d_fish_eaten():
	print("Fish Eaten")
	timer.start(timer.time_left + 5)
	
	#tween to make the text gradually fade
	if (eaten_label.modulate.a == 0.0):
		eaten_label.modulate.a = 1.0
		var tween = create_tween()
		tween.tween_property(eaten_label, "modulate:a", 0.0, 2.0)
		
