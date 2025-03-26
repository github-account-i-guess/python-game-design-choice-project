extends Node

var check_point_pos:Vector3

func save_check_point(pos_x, pos_y, pos_z):
	check_point_pos.x = pos_x
	check_point_pos.y = pos_y
	check_point_pos.z = pos_z
	
func return_checkpoint():
	save_check_point(0,0,0)
	return check_point_pos
