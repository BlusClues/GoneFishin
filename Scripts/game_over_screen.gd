extends Node2D

var is_gameover = false
var sent_signal = false

signal gameover_pause(is_gameover_paused: bool)

#set the game over as invisible at first
func _ready():
	self.visible = false

func _process(delta: float):
	if is_gameover and !sent_signal:
		self.visible = true
		gameover_pause.emit(is_gameover)
		sent_signal = true

#replay if press play again
func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()

#quit game if press the button
func _on_quit_game_pressed() -> void:
	get_tree().quit()

#checks if the time has ran out
func _on_timer_game_over() -> void:
	is_gameover = true
