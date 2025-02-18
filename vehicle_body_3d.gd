extends VehicleBody3D
@export var added_engine_force = 30

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)
var boost = 0
#var target_velocity = Vector3.ZERO
func _physics_process(delta):
	engine_force = max(engine_force, 0)
	var velocity = linear_velocity
	velocity.y = 0
	var speed = velocity.length()
	#var direction = Vector3.ZERO
	var steeringCap = PI/3

	var drifting = Input.is_action_pressed("drift")
	$BackLeftWheel.use_as_traction = not drifting
	$BackRightWheel.use_as_traction = not drifting
	#$FrontLeftWheel.use_as_traction = not drifting
	#$FrontRightWheel.use_as_traction = not drifting
	if Input.is_action_pressed("move_right") and angle > -steeringCap:
		#direction.x -= 10
		angle -= 0.05
	elif  Input.is_action_pressed("move_left") and angle < steeringCap:
		#direction.x += 10	
		angle += 0.05
	else:
		angle -= 0.01 * sign(angle)
	if Input.is_action_pressed("move_forward"):
		if engine_force < 10000:
			engine_force += added_engine_force
	else:
		##brake = 0.2
		engine_force -= 100
		#accelTime -= 1
	if Input.is_action_pressed("move_back"):
		if speed > 10:
			brake = 2.0
		engine_force -= 200
	if drifting:
		steeringCap = PI/4
		boost += 5
	else:
		if boost > 0:
			engine_force += boost * 5
			boost -= 1
	#engine_force = speedMap(accelTime)
	$Camera3D.setFov(sqrt(speed) + 90)
	print(speed)
	steering = angle
	
