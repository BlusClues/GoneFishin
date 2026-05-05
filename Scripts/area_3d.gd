extends Area3D

#inheritable to both the lure and fish

#detect collision on the object
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	queue_free()
