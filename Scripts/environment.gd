extends CSGBox3D

var player

var point_1: Vector3
var point_2: Vector3

@onready var fishes: Resource = preload("res://Scenes/Fish.tscn")
@onready var lures: Resource = preload("res://Scenes/Lure.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("Player")
	
	randomize()
	point_1 = Vector3(-16.8, 9.5, 173.4)
	point_2 = Vector3(16.8, -9.5, -65.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player.global_position.z  > 199:
		#print("reached")
		spawn_fishes()
		spawn_fishes()
		spawn_fishes()
		spawn_lures()
		
	for f in get_tree().get_nodes_in_group("fish"):
		for l in get_tree().get_nodes_in_group("lure"):
		
			#reset fishes
			if player.global_position.z < -70:
				remove_child(l)
				l.queue_free()
				remove_child(f)
				f.queue_free()
			#if spawn too close to each other
			elif f.global_position.distance_to(l.global_position) < 2.0:
				print("fish got caught")
				remove_child(l)
				l.queue_free()
				remove_child(f)
				f.queue_free()

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
	
func spawn_lures():
	#print("fish has spawned")
	var lure_instance: Node = lures.instantiate()
	
	add_child(lure_instance)
	
	var spawner_location: Vector3 = get_random_point_inside(point_1, point_2)
	
	lure_instance.position = spawner_location
