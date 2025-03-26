class_name CheckPoint
extends Area3D

static var check_point_pos:Vector3

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(_body:Node3D) -> void:
	print("checkpoint")
	get_parent().check_point_pos = global_position
