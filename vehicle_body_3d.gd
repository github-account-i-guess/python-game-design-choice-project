extends VehicleBody3D
@export var added_engine_force = 3000

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)
var numCheckpoints = 0
var check_point = Vector3.ZERO
var slow = false
var numBodiesCollided = 0
var jumpSpeed = 20

var boost = 0
var prevSpeed = 0
var frontWheels: Array[VehicleWheel3D]
var wheels: Array[VehicleWheel3D]
var backWheels: Array[VehicleWheel3D]
var fastFall = 0
var airTime = 0
var airDashAvailable = false
var airBoost = 0
var curCheckpoint = -1
var laps = 0
var lapTimes = []
var time = 0
var lapTime = 0
#var target_velocity = Vector3.ZERO
func _ready():
	backWheels = [$BackLeftWheel, $BackRightWheel]
	frontWheels = [$FrontLeftWheel, $FrontRightWheel]
	wheels = backWheels.duplicate()
	wheels.append_array(frontWheels)
	#print(wheels)
	for wheel in wheels:
		wheel.wheel_roll_influence = 0
		wheel.wheel_friction_slip = 8

func _physics_process(delta):
	#print(delta)
	var velocity = linear_velocity
	velocity.y = 0
	var speed = velocity.length()
	#var direction = Vector3.ZERO
	var steeringCap = PI/3

	var drifting = Input.is_action_pressed("drift")
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	if Input.is_action_pressed("move_forward"):
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
		engine_force = -added_engine_force 
		#linear_velocity *= 0.9999
	#if Input.is_action_just_pressed("drift"):
			#linear_velocity += Vector3(0, 30, 0)
	if drifting and airTime < 60:
		if (left or right) and boost < 60:
			boost += 1

		for wheel in backWheels:
			wheel.wheel_friction_slip = 1
		#for wheel in frontWheels:
			#wheel.wheel_friction_slip = 10
		if right:
			$BackLeftWheel.wheel_roll_influence = 5
		if left:
			$BackRightWheel.wheel_roll_influence = 5
		$BodyMesh.mesh.material.albedo_color = Color(0, 0, 1, 0.5)
	else:
		for wheel in wheels:
			wheel.wheel_friction_slip = 10.5
		$BodyMesh.mesh.material.albedo_color = Color(0, 1, 0, 0.5)
		for wheel in backWheels:
			wheel.wheel_roll_influence = 0
	if Input.is_action_just_released('drift') and not Input.is_action_pressed("move_back") and (numBodiesCollided > 0 or airDashAvailable):
		var direction = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), steering + global_rotation.y)
		var increasedDirection = direction.normalized() * 10 * (boost/3)
		linear_velocity += increasedDirection
		angular_velocity = angular_velocity.normalized() * min(angular_velocity.length(), 1/2)
		boost = 0
	if Input.is_action_pressed("jump") and numBodiesCollided > 0:
		print("jump")
		linear_velocity.y = jumpSpeed
				
	#engine_force = speedMap(accelTime)

	$Camera.setFov(sqrt(speed) + 90)

	steering = angle

	#if linear_velocity.y >= 0:
		#print(speed)
	if slow and linear_velocity.length() > 75:
		linear_velocity -= linear_velocity.normalized() * 34
	#print(fastFall)
	if fastFall > 0:
		if linear_velocity.y > 0:
			fastFall = 0
		gravity_scale = 20
		global_rotation.x = 0
		global_rotation.z = 0
		$BodyMesh.mesh.material.albedo_color = Color(1, 0, 0, 0.5)
		fastFall -= 1
	else:
		gravity_scale = 3
	if numBodiesCollided == 0:
		if airTime == 0:
			airDashAvailable = true
		airTime += 1
	elif airTime:
		airTime = 0
	lapTime += delta
	#print (airDashAvailable)

func _on_body_entered(body: Node):
	print("body: " + str(body))
	if (body.is_in_group("slow")):
		slow = true
	if (body.is_in_group("fast_fall")):
		fastFall = 120
	numBodiesCollided += 1
	
func _on_body_exited(body: Node) -> void:
	print("body: " + str(body))
	if (body.is_in_group("slow")):
		slow = false
	numBodiesCollided -= 1
	 # Replace with function body.

func _on_vehicle_area_entered(area: Area3D) -> void:
	print("area: " + str(area))
	if area.is_in_group("boost"):
		print("boosted")
		linear_velocity += 200 * Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), area.global_rotation.y)
	if area.is_in_group("checkpoint"):
		save_check_point(area)
		var num = area.checkpointNum
		print(numCheckpoints)

		if num == curCheckpoint + 1:
			curCheckpoint = num
		if curCheckpoint == numCheckpoints - 1 and num == 0:
			curCheckpoint = num
			laps += 1
			time += lapTime
			lapTimes.append(lapTime)
			lapTime = 0
	if area.is_in_group("deathzone"):
		global_position = check_point.global_position
		angular_velocity = Vector3.ZERO
		linear_velocity = Vector3.ZERO
		global_rotation = check_point.global_rotation
	# Replace with function body.


func save_check_point(checkpoint):
	check_point = checkpoint
