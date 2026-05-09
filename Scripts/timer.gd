extends Node2D

@onready var stamina_bar = $CanvasLayer/StaminaPanel/StaminaBar
@onready var eaten_label = $CanvasLayer/StaminaPanel/EatenLabel
@onready var escape_panel = $CanvasLayer/EscapePanel
@onready var escape_bar = $CanvasLayer/EscapePanel/EscapeProgress
@onready var points_label = $CanvasLayer/PointsPanel/PointsLabel
@onready var fish_point_label = $CanvasLayer/PointsPanel/FishPointIncreaseLabel
@onready var escape_point_label = $CanvasLayer/PointsPanel/LureEscapeIncreaseLabel

var current_stamina
var is_dashing = false
var ate_lure = false
var escape_button_presses = 0.0
var max_escape_amount = 20
var current_points = 0
var points_timer
var just_dashed
var tween_points
var tween_stamina
var fish_eaten_num = 0
var double_points = false
var double_points_timer
var points_rate = 1.0
var lure_escape_cards = 0
var stomach_size = 1.0
var evaded_lure = false

const STAMINA_TIME = 10
const DASH_MULTIPLIER = 2.0
const FISH_POINT_INCREASE = 100
const POINTS_TIMER_INCREMENT_SPEED = 0.1
const STAMINA_FISH_INCREASE_TIME = 5.0
const STAMINA_LURE_DECREASE_TIME = 2.0
const LURE_ESCAPE_INCREASE = 200
const DOUBLE_POINTS_TIMER_DEFAULT = 20.0 # ~20 seconds

signal game_over
signal gain_buff

func _ready():
	points_timer = POINTS_TIMER_INCREMENT_SPEED
	current_stamina = STAMINA_TIME
	
	#set the eaten label to invisible
	eaten_label.modulate.a = 0.0
	fish_point_label.modulate.a = 0.0
	escape_point_label.modulate.a = 0.0
	
	#initalize the progress bar
	stamina_bar.max_value = STAMINA_TIME
	stamina_bar.value = STAMINA_TIME

func _process(delta):
	#normal rate 
	var countdown_speed = 1.0
	if !ate_lure:
		#switch to dashing rate
		if is_dashing:
			countdown_speed = DASH_MULTIPLIER
			just_dashed = true
		elif !is_dashing:
			just_dashed = false
	elif ate_lure:
		#make the timer work but slower when hooked
		countdown_speed = 0.5
		
		#set the escape mashing bar
		escape_bar.value = escape_button_presses
		
		#reset variables when the player escapes
		if escape_button_presses >= max_escape_amount:
			escape_panel.visible = false
			escape_button_presses = 0.0
			ate_lure = false
			
			current_points += LURE_ESCAPE_INCREASE * points_rate
			escape_point_label.modulate.a = 1.0
			tween_points = create_tween()
			tween_points.tween_property(escape_point_label, "modulate:a", 0.0, 2.0)
			
	
	#make hunger tick down depending on rate
	current_stamina -= delta * countdown_speed
	current_stamina = clamp(current_stamina, 0, STAMINA_TIME * stomach_size)
	stamina_bar.value = current_stamina
	
	#activate double points buff
	if double_points:
		double_points_timer -= delta
		if double_points_timer <= 0:
			double_points = false
			points_rate = 1.0
	
	#make the points increase with time
	points_timer -= delta
	if points_timer <= 0:
		current_points += 1 * points_rate
		if !just_dashed:
			points_timer = POINTS_TIMER_INCREMENT_SPEED
		elif just_dashed:
			points_timer = POINTS_TIMER_INCREMENT_SPEED / 2
	
	#what happens when timer runs out
	if current_stamina <= 0:
		escape_panel.visible = false
		game_over.emit()
	else:
		#update the points label
		points_label.text = "Points: " + str(int(current_points))

#checks if the player is still dashing
func _on_player_dash_state_changed(is_player_dashing: bool):
	is_dashing = is_player_dashing

#when you eat a fish add time to timer
#signal from camera_3d
func _on_collision_shape_3d_fish_eaten():
	print("Fish Eaten")
	if !ate_lure:
		#increase points and stamina
		current_stamina += STAMINA_FISH_INCREASE_TIME
		current_points += FISH_POINT_INCREASE * points_rate
		
		#kill current tween if it currently exists
		if tween_points and tween_points.is_running():
			tween_points.kill()
		
		#tween to make the text gradually fade for points
		fish_point_label.modulate.a = 1.0
		tween_points = create_tween()
		tween_points.tween_property(fish_point_label, "modulate:a", 0.0, 2.0)
		
		if tween_stamina and tween_stamina.is_running():
			tween_stamina.kill()
		
		#tween to make the text gradually fade for stamina
		eaten_label.modulate.a = 1.0
		tween_stamina = create_tween()
		tween_stamina.tween_property(eaten_label, "modulate:a", 0.0, 2.0)
		
		#track the amount of fish eaten
		fish_eaten_num += 1
		print(fish_eaten_num)
		if fish_eaten_num % 5 == 0:
			gain_buff.emit()

func _on_collision_shape_3d_lure_eaten():
	#when you eat a lure reduce stamina
	if lure_escape_cards <= 0:
		if !evaded_lure:
			print("Lure Eaten")
			current_stamina -= STAMINA_LURE_DECREASE_TIME
			ate_lure = true
			escape_panel.visible = true
		else:
			evaded_lure = false
	else:
		lure_escape_cards -= 1
		print("you used one of your cards")

#Counts how many button presses there have been
func _on_player_current_button_presses(button_presses: float):
	escape_button_presses = button_presses

#gets the max number of button presses needed
func _on_player_max_buttons_needed(max_amount_needed: float):
	max_escape_amount = max_amount_needed
	
	#setting the mashing progress bar
	escape_bar.max_value = max_escape_amount

#check if the double points buff was chosen
func _on_buff_cards_buff_double_points():
	double_points = true
	points_rate = 2.0
	double_points_timer = DOUBLE_POINTS_TIMER_DEFAULT

#checks if you have chosen the next lure free buff
func _on_buff_cards_buff_next_lure_free():
	lure_escape_cards += 1

#checks if you have chosen the bigger stomach buff
func _on_buff_cards_buff_bigger_stomach():
	stomach_size += 0.1
	stamina_bar.max_value = STAMINA_TIME * stomach_size
	print(stamina_bar.max_value)

func _on_player_evaded_lure():
	evaded_lure = true
