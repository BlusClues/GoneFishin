extends Node3D

@onready var lure1 = $Area3D/Lure_1
@onready var lure2 = $Area3D/Lure_2
@onready var lure_list = [lure1, lure2]

#randomly pick a sprite to make visible from the list
func _ready():
	var lure_model = lure_list[randi_range(0, lure_list.size() - 1)]
	lure_model.visible = true




















	
	
	#add shine to the lure
	#material = fish_mesh.get_active_material(0)
	#material.emission_energy_multiplier = 2.0

#TODO Change the lure feature to make sure that it aligns with the core pillars
#This should be scraped now for the current idea. right now this is trying to 
#implement the escape sequence which does work but weirdly.
#works by making the current object invisible and then you escape.
#can add the feature later but for now just scrap to get other stuff working.

#Function that runs the system for trying to escape
#func _process(delta):
	##if lure is eaten
	#if hooked_on_lure == true:
		##if Input.is_action_just_pressed("Escape"):
			#current_mash_amount = current_mash_amount + 1
			#if current_mash_amount >= mash_amount and escaped == false:
				#print("escaped!" + str(current_mash_amount))
				#escaped == true


#func _on_camera_3d_lure_eaten():
	#print("ate lure")
	#hooked_on_lure = true
	#self.visible = false
	#get_tree().quit()
	#make mash system where it tracks how many button presses
	#progressbar on screen for showign that you mashed enough
