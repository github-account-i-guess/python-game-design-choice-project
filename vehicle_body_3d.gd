extends VehicleBody3D

@export var added_engine_force = 300

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)

#var target_velocity = Vector3.ZERO
func _physics_process(delta):
	var velocity = linear_velocity
	velocity.y = 0
	var speed = velocity.length()
	#var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right") and angle > -PI/3:
		#direction.x -= 10
		angle -= 0.05
	elif  Input.is_action_pressed("move_left") and angle < PI/3:
		#direction.x += 10	
		angle += 0.05
	else:
		angle -= 0.01 * sign(angle)
	if Input.is_action_pressed("move_forward"):
		engine_force = added_engine_force
	else:
		#brake = 0.2
		engine_force = 0
		#accelTime -= 1
	if Input.is_action_pressed("move_back"):
		#engine_force -= 10
		brake = 2.0
	#engine_force = speedMap(accelTime)
	print(speed)
	$Camera3D.setFov(speed/2 + 90)
	steering = angle
	
