extends VehicleBody3D
@export var added_engine_force = 3000

@export var angle = 0

@export var normalAxis = Vector3(0, 1, 0)
var check_point_pos = Vector3.ZERO
var slow = false
var numBodiesCollided = 0

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
		engine_force = -added_engine_force/2
	#if Input.is_action_just_pressed("drift"):
			#linear_velocity += Vector3(0, 30, 0)
	if drifting and numBodiesCollided > 0:
		if (left or right) and boost < 120:
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
	if Input.is_action_just_released('drift') and not Input.is_action_pressed("move_back"):
		var direction = Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), steering + global_rotation.y)
		var increasedDirection = direction.normalized() * 10 * (boost/3) 

		linear_velocity += increasedDirection
		angular_velocity = angular_velocity.normalized() * min(angular_velocity.length(), 1/2)
		boost = 0
	#engine_force = speedMap(accelTime)

	$Camera.setFov(sqrt(speed) + 90)

	steering = angle

	#if linear_velocity.y >= 0:
		#print(speed)
	if slow and linear_velocity.length() > 75: 
		linear_velocity -= linear_velocity.normalized() * 34


func _on_body_entered(body: Node):
	print("body: " + str(body))
	if (body.is_in_group("slow")):
		slow = true
	numBodiesCollided += 1
	pass
func _on_body_exited(body: Node) -> void:
	print("body: " + str(body))
	if (body.is_in_group("slow")):
		slow = false
	numBodiesCollided -= 1
	pass # Replace with function body.

func _on_vehicle_area_entered(area: Area3D) -> void:
	print("area: " + str(area))
	if area.is_in_group("boost"):
		print("boosted")
		linear_velocity += 200 * Vector3(0, 0, 1).rotated(Vector3(0, 1, 0), area.global_rotation.y)
	pass # Replace with function body.

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("detect")
	save_check_point(self.position.x, self.position.y, self.position.z)


func _on_deathzone_area_entered(area: Area3D) -> void:
	print("die")
	global_position = check_point_pos

func save_check_point(pos_x, pos_y, pos_z):
	check_point_pos.x = pos_x
	check_point_pos.y = pos_y
	check_point_pos.z = pos_z
