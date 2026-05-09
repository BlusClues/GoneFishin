extends Node2D

@onready var json_file = "res://Scripts/buffs.json"
@onready var cards_window = $CardPanel
@onready var card1_label = $CardPanel/Card1/Buff1Label
@onready var card1_desc = $CardPanel/Card1/Description1Label
@onready var card2_label = $CardPanel/Card2/Buff2Label
@onready var card2_desc = $CardPanel/Card2/Description2Label

var buff_data
var card1_data
var card2_data
var card1_id
var card2_id
var picked_id
var buff_library = {}

signal buff_pause(is_paused: bool)
signal buff_double_points()
#signal buff_next_lure_free()

func _ready():
	#gather the json data
	buff_data = load_json_file(json_file)
	for buff in buff_data["buffs"]:
		var id = int(buff["id"])
		buff_library[id] = buff
	
	#make the cards invisible at first
	cards_window.visible = false

#read json file and return contents
func load_json_file(path: String):
	if not FileAccess.file_exists(path):
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	return data

#choose and update the data that is on the cards
func update_cards():
	#get random numbers for the buffs
	#card1_id = randi_range(1, 7)
	card1_id = 5
	card2_id = randi_range(1, 7)
	
	#choose random buffs
	card1_data = buff_library[card1_id]
	card2_data = buff_library[card2_id]
	
	#set card 1 values
	card1_label.text = card1_data["name"]
	card1_desc.text = card1_data["description"]
	
	#set card 2 values
	card2_label.text = card2_data["name"]
	card2_desc.text = card2_data["description"]

#checks if the player has met the condition for gaining buff
func _on_timer_gain_buff():
	print("I got a buff")
	#update the cards and pause the window
	update_cards()
	cards_window.visible = true
	buff_pause.emit(true)

func process_chosen_buff(id: int):
	#clear cards and unpause window
	cards_window.visible = false
	buff_pause.emit(false)
	
	#check which buff was chosen
	match id:
		#1:
			#buff_next_lure_free.emit()
		5:
			buff_double_points.emit()

#checks if card 1 was clicked
func _on_card_1_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		process_chosen_buff(card1_id)

#checks if cards 2 was clicked
func _on_card_2_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		process_chosen_buff(card2_id)

#Check if the game over screen is visible
func _on_game_over_screen_gameover_pause(is_gameover_paused: bool):
	cards_window.visible = !is_gameover_paused
