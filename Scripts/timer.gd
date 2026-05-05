extends Node2D

@onready var stamina_bar = $CanvasLayer/Panel/StaminaBar
@onready var eaten_label = $CanvasLayer/Panel/EatenLabel
@onready var timer = $Timer

var stamina_time = 10
var current_stamina
var dash_multiplier = 2.0
var dashing = false

func _ready():
	current_stamina = stamina_time
	
	#set the eaten label to invisible
	eaten_label.modulate.a = 0.0
	
	#initalize the progress bar
	stamina_bar.max_value = stamina_time
	stamina_bar.value = stamina_time

func _process(delta):
	#check if dashing
	if Input.is_action_pressed("Escape"):
		dashing = true
	else:
		dashing = false
	
	#normal rate 
	var speed = 1.0
	
	#switch to dashing rate
	if dashing == true:
		speed = dash_multiplier
	
	#make hunger tick down depending on rate
	current_stamina -= delta * speed
	current_stamina = clamp(current_stamina, 0, stamina_time)
	stamina_bar.value = current_stamina
	
	#what happens when timer runs out
	if current_stamina <= 0:
		print("Timer Stop")

#when you eat a fish add time to timer
#signal from camera_3d
func _on_camera_3d_fish_eaten():
	print("Fish Eaten")
	current_stamina += 5
	
	#tween to make the text gradually fade
	if (eaten_label.modulate.a == 0.0):
		eaten_label.modulate.a = 1.0
		var tween = create_tween()
		tween.tween_property(eaten_label, "modulate:a", 0.0, 2.0)
