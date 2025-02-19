extends VehicleBody3D
@export var added_engine_force = 3000

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
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	if right and angle > -steeringCap:
		#direction.x -= 10
		angle -= 0.05
	elif left and angle < steeringCap:
		#direction.x += 10	
		angle += 0.05
	else:
		angle -= 0.01 * sign(angle) * (1 + speed/30)
	if Input.is_action_pressed("move_forward"):
		engine_force = added_engine_force
	else:
		##brake = 0.2
		engine_force -= 100
		#accelTime -= 1
	if Input.is_action_pressed("move_back"):
		if speed > 10:
			brake = 2.0
		engine_force = -added_engine_force/2
	if drifting:
		#steeringCap = PI/4
		if (left or right) and boost < 100:
			boost += 1
		engine_force = 0
		$BackLeftWheel.wheel_friction_slip = 8
		$BackRightWheel.wheel_friction_slip = 8
	else:
		if boost > 0:
			engine_force += boost * 5000
			boost -= 10
		$BackLeftWheel.wheel_friction_slip = 12.5
		$BackRightWheel.wheel_friction_slip = 12.5
	#engine_force = speedMap(accelTime)
	$Camera3D.setFov(sqrt(speed) + 90)
	print(speed)
	steering = angle
	
