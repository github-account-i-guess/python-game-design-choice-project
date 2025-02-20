extends VehicleBody3D
@export var added_engine_force = 2100

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)
var boost = 0
var prevSpeed = 0
var frontWheels: Array[VehicleWheel3D]
var wheels: Array[VehicleWheel3D]
var backWheels: Array[VehicleWheel3D]
#var target_velocity = Vector3.ZERO
func _ready():
	backWheels = [$BackLeftWheel, $BackRightWheel]
	frontWheels = [$FrontLeftWheel, $FrontRightWheel]
	wheels = backWheels.duplicate()
	wheels.append_array(frontWheels)
	#print(wheels)
	for wheel in wheels:
		wheel.wheel_roll_influence = 0

func _physics_process(delta):
	#print(delta)
	engine_force = 0
	var velocity = linear_velocity
	velocity.y = 0
	var speed = velocity.length()
	#var direction = Vector3.ZERO
	var steeringCap = PI/3

	var drifting = Input.is_action_pressed("drift")
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	if Input.is_action_pressed("move_forward") and not drifting:
		engine_force = added_engine_force
	else:
		##brake = 0.2
		engine_force *= 9/10
		#accelTime -= 1
	if right and angle > -steeringCap:
		#direction.x -= 10
		angle -= 0.05
	if left and angle < steeringCap:
		#direction.x += 10	
		angle += 0.05
	if not (left or right):
		angle -= 0.01 * sign(angle) * (1 + speed/30)

	if Input.is_action_pressed("move_back"):
		if speed > 10:
			brake = 2.0
		engine_force = -added_engine_force/2
	if drifting:
		#steeringCap = PI/4
		if (left or right) and boost < 48:
			boost += 1
		#engine_force = 0
		#brake = 1
		#for wheel in backWheels:
			#wheel.wheel_friction_slip = 8
			##wheel.wheel_roll_influence = 100
		#for wheel in frontWheels:
			#wheel.wheel_friction_slip = 10
		if left:
			$BackLeftWheel.wheel_roll_influence = 20
		if right:
			$BackRightWheel.wheel_roll_influence = 20
					
		#$FrontLeftWheel.wheel_friction_slip = 10
		#$FrontRightWheel.wheel_friction_slip = 10
		$BodyMesh.mesh.material.albedo_color = Color(0, 0, 1, 0.5)		
	else:
		#for wheel in wheels:
			#wheel.wheel_friction_slip = 10.5
		#if boost > 0:
			#boost -= 1
			##$BodyMesh.mesh.material.albedo_color = Color(0, 1, 0, 0.5)
			##linear_velocity.y = 0
			##if abs(linear_velocity.y) > 0.01:
				##glo.y = 0
			#if boost < 2 or abs(steering) < 1:
				#
		#else:
		$BodyMesh.mesh.material.albedo_color = Color(1, 0, 0, 0.5)		
		for wheel in backWheels:
			wheel.wheel_roll_influence = 0
	if Input.is_action_just_released('drift') and not Input.is_action_pressed("move_back"):
		var direction = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), global_rotation.y)
		print(direction)
		linear_velocity += direction.normalized() * 10 * (0.3 + boost/4) 
		boost = 0	
	#engine_force = speedMap(accelTime)
	#for wheel in wheels:
		#print(wheel.wheel_roll_influence)
	$Camera.setFov(sqrt(speed) + 90)
	#print(speed)
	#print(engine_force)
	steering = angle
	#if linear_velocity.y >= 0:
		#print(speed)
	#print(speed - prevSpeed)
	#prevSpeed = speed
	#rotation.x = 0
	#rotation.z = 0
	#if (left != right):
		#linear_velocity.z += 1
	
