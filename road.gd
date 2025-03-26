extends StaticBody3D
@export var length = 1200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if length != 1200:
		$Mesh.mesh = $Mesh.mesh.duplicate()
		$Collision.shape = $Collision.shape.duplicate()
		$Mesh.mesh.size.x = length
		$Collision.shape.size.x = length
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
