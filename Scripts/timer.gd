extends Node2D

@onready var stamina_bar = $CanvasLayer/StaminaPanel/StaminaBar
@onready var eaten_label = $CanvasLayer/StaminaPanel/EatenLabel
@onready var escape_panel = $CanvasLayer/EscapePanel
@onready var escape_bar = $CanvasLayer/EscapePanel/EscapeProgress

var stamina_time = 10
var current_stamina
var dash_multiplier = 2.0
var is_dashing = false
var ate_lure = false
var escape_button_presses = 0.0
var max_escape_amount = 20

signal game_over

func _ready():
	current_stamina = stamina_time
	
	#set the eaten label to invisible
	eaten_label.modulate.a = 0.0
	
	#initalize the progress bar
	stamina_bar.max_value = stamina_time
	stamina_bar.value = stamina_time

func _process(delta):
	#normal rate 
	var speed = 1.0
	if !ate_lure:
		#switch to dashing rate
		if is_dashing:
			speed = dash_multiplier
	elif ate_lure:
		#make the timer work but slower when hooked
		speed = 0.5
		
		#set the escape mashing bar
		escape_bar.value = escape_button_presses
		
		#reset variables when the player escapes
		if escape_button_presses >= max_escape_amount:
			escape_panel.visible = false
			escape_button_presses = 0.0
			ate_lure = false
	
	#make hunger tick down depending on rate
	current_stamina -= delta * speed
	current_stamina = clamp(current_stamina, 0, stamina_time)
	stamina_bar.value = current_stamina
	
	#what happens when timer runs out
	if current_stamina <= 0:
		game_over.emit()

#checks if the player is still dashing
func _on_player_dash_state_changed(is_player_dashing: bool):
	is_dashing = is_player_dashing

#when you eat a fish add time to timer
#signal from camera_3d
func _on_collision_shape_3d_fish_eaten():
	print("Fish Eaten")
	current_stamina += 5
	
	#tween to make the text gradually fade
	if (eaten_label.modulate.a == 0.0):
		eaten_label.modulate.a = 1.0
		var tween = create_tween()
		tween.tween_property(eaten_label, "modulate:a", 0.0, 2.0)

func _on_collision_shape_3d_lure_eaten():
	#when you eat a lure reduce stamina
	print("Lure Eaten")
	current_stamina -= 2.0
	ate_lure = true
	
	escape_panel.visible = true

#Counts how many button presses there have been
func _on_player_current_button_presses(button_presses: float):
	escape_button_presses = button_presses

#gets the max number of button presses needed
func _on_player_max_buttons_needed(max_amount_needed: float):
	max_escape_amount = max_amount_needed
	
	#setting the mashing progress bar
	escape_bar.max_value = max_escape_amount
