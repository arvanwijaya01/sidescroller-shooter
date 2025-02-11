extends Node2D

onready var front_hand = $Torso/FrontArmNode/FrontArm/LowerArm/Hand
onready var back_hand = $Torso/BackArmNode/BackArm/LowerArm/Hand

func attach_to_front_arm(obj:Node2D):
	obj.global_position = front_hand.global_position
	obj.global_rotation = front_hand.global_rotation + deg2rad(90.0)

func attach_to_back_arm(obj:Node2D):
	obj.global_position = back_hand.global_position
	obj.global_rotation = back_hand.global_rotation + deg2rad(90.0)
