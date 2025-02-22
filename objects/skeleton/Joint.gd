extends PinJoint2D

export var min_angle = 0.0
export var max_angle = 90.0

func _physics_process(delta):
	var nodea = get_node(node_a)
	var nodeb = get_node(node_b)
	var rotationa = nodea.rotation_degrees
	var rotationb = nodeb.rotation_degrees
	var diff = rotationa - rotationb
	diff = 360 - diff if diff > 180 else diff
	diff = diff - 360 if diff < -180 else diff
	print(rotationb, "+", rotationa, "=", diff)
#	if rotationa < rotationb + min_angle:
	if diff < min_angle:
		nodea.angular_velocity = 5
#	elif rotationa > rotationb + max_angle:
	elif diff > max_angle:
		nodea.angular_velocity = -5
	else:
		nodea.angular_velocity = 0
