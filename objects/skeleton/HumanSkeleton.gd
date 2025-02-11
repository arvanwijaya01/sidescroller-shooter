extends Node2D

var aiming_is_active = false
onready var front_hand = $Torso/FrontArmNode/FrontArm/LowerArm/Hand
onready var back_hand = $Torso/BackArmNode/BackArm/LowerArm/Hand
onready var head_node = $Torso/HeadNode
onready var back_arm_node = $Torso/BackArmNode
onready var front_arm_node = $Torso/FrontArmNode

func _physics_process(_delta):
	if aiming_is_active:
		head_node.rotation = head_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		back_arm_node.rotation = back_arm_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		front_arm_node.rotation = front_arm_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		head_node.rotation -= $Torso.rotation
		back_arm_node.rotation -= $Torso.rotation
		front_arm_node.rotation -= $Torso.rotation
	else:
		head_node.rotation = 0
		back_arm_node.rotation = 0
		front_arm_node.rotation = 0

func attach_to_front_arm(obj:Node2D):
	obj.global_position = front_hand.global_position
	obj.global_rotation = front_hand.global_rotation + deg2rad(90.0)

func attach_to_back_arm(obj:Node2D):
	obj.global_position = back_hand.global_position
	obj.global_rotation = back_hand.global_rotation + deg2rad(90.0)
