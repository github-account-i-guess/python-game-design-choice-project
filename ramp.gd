extends StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("a")
	#var parent = self.get_parent()
	#for i in range(3):
		#var dup = load("../ramp").
		#get_tree().current_scene.add_child(dup)		
		#dup.rotateSelf(i)
		##parent.add_child(dup)
		#print(parent.get_child_count())
		#print(self.get_parent().get_children())
	#print(global_position)
	pass # Replace with function body.

func rotateSelf(i: int):
	transform = transform.rotated(Vector3(0, 1, 0), (i+1)*PI/2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
