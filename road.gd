extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector3(0, 0, 0))
	if collision:
		print(collision.get_collider(0))
func body_entered(body: Node3D):
	print("body entered")
func area_entered(body: Node3D):
	print("area entered")
