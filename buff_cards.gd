extends Node2D

@onready var json_file = "res://Scripts/buffs.json"
@onready var cards_window = $CardPanel

var buff_data
var card1_data
var card2_data

func _ready():
	#gather the json data
	buff_data = load_json_file(json_file)
	#for key in buff_data:
		#card1_data = buff_data
	
	#make the cards invisible at first
	cards_window.visible = false
	


func _process(delta: float):
	print(card1_data)

#read json file and return contents
func load_json_file(path: String):
	if not FileAccess.file_exists(path):
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	return data
