extends CSGBox3D

var player

var point_1: Vector3
var point_2: Vector3

@onready var fishes: Resource = preload("res://Scenes/Fish.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("Player")
	
	randomize()
	point_1 = Vector3(-16.8, 9.5, 173.4)
	point_2 = Vector3(16.8, -9.5, -65.3)
	
	spawn_fishes()
	spawn_fishes()
	spawn_fishes()
	spawn_fishes()
	spawn_fishes()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player.global_position.z  > 195:
		#print("reached")
		spawn_fishes()
		spawn_fishes()
		spawn_fishes()
		spawn_fishes()
		spawn_fishes()
	
	for fish in get_tree().get_nodes_in_group("fish"):
		if player.global_position.z  < -65:
			print("deleted")
			remove_child(fish)
			fish.queue_free()
	

func get_random_point_inside(p1: Vector3, p2: Vector3) -> Vector3:
	
	var x_value: float = randf_range(p1.x , p2.x)
	var y_value: float = randf_range(p1.y , p2.y)
	var z_value: float = randf_range(p1.z , p2.z)
	
	var random_point_inside: Vector3 = Vector3(x_value, y_value, z_value)
	
	return(random_point_inside)

func spawn_fishes():
	#print("fish has spawned")
	var fish_instance: Node = fishes.instantiate()
	
	add_child(fish_instance)
	
	var spawner_location: Vector3 = get_random_point_inside(point_1, point_2)
	
	fish_instance.position = spawner_location
	
