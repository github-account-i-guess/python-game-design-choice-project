extends Node3D
# Called when the node enters the scene tree for the first time.

func rotateSelf(i: int, angle:float):
	transform = transform.rotated(Vector3(0, 1, 0), (i+1) * angle)
