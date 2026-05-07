extends Node2D

var is_gameover = false

#TODO
#1 hook up buttons in this script
#2 make screen show up from other scripts when certain actions happen
#pasue game when screen comes up

func _ready():
	self.visible = false

func _process(delta: float):
	if is_gameover:
		self.visible = true
		get_tree().paused = true

func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_timer_game_over() -> void:
	is_gameover = true
