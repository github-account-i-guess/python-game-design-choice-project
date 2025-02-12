extends VehicleBody3D

@export var added_engine_force = 300

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)

#var target_velocity = Vector3.ZERO


func _physics_process(delta):
	#var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		#direction.x -= 10
		angle -= 0.1
	if Input.is_action_pressed("move_left"):
		#direction.x += 10	
		angle += 0.1
	if Input.is_action_pressed("move_back"):
		engine_force -= 10
	if Input.is_action_pressed("move_forward"):
		engine_force = added_engine_force
	steering = angle
	brake = 0
