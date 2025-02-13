extends Node2D

var aiming_is_active = false setget set_aiming_is_active
onready var front_hand = $Torso/FrontArmNode/FrontArm/LowerArm/Hand
onready var back_hand = $Torso/BackArmNode/BackArm/LowerArm/Hand
onready var head_node = $Torso/HeadNode
onready var back_arm_node = $Torso/BackArmNode
onready var front_arm_node = $Torso/FrontArmNode
onready var torso = $Torso
onready var tween = $Tween
onready var footstep_audio = $FootstepAudio

func _physics_process(_delta):
	if aiming_is_active:
		var arm_target_rotation = front_arm_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		arm_target_rotation = get_global_mouse_position().angle_to_point(front_arm_node.global_position + (Vector2(0.0, -7.0)).rotated(scale.x * arm_target_rotation))
		arm_target_rotation = arm_target_rotation if scale.x > 0 else deg2rad(180.0) - arm_target_rotation
		arm_target_rotation -= torso.rotation
		var head_target_rotation = head_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		head_node.rotation = lerp_angle(head_node.rotation, head_target_rotation, 0.5)
		back_arm_node.rotation = lerp_angle(back_arm_node.rotation, arm_target_rotation, 0.5)
		front_arm_node.rotation = lerp_angle(front_arm_node.rotation, arm_target_rotation, 0.5)
		# 21 + 18 = 39 , -7
	else:
		head_node.rotation = lerp_angle(head_node.rotation, 0.0, 0.5)
		back_arm_node.rotation = lerp_angle(back_arm_node.rotation, 0.0, 0.5)
		front_arm_node.rotation = lerp_angle(front_arm_node.rotation, 0.0, 0.5)

func play_footstep_audio():
	footstep_audio.pitch_scale = rand_range(1.8, 2.2)
	footstep_audio.play(0.0)

func set_aiming_is_active(is_active : bool):
	aiming_is_active = is_active

func attach_to_front_arm(obj:Node2D):
	obj.global_position = front_hand.global_position
	obj.global_rotation = front_hand.global_rotation + deg2rad(90.0)

func attach_to_back_arm(obj:Node2D):
	obj.global_position = back_hand.global_position
	obj.global_rotation = back_hand.global_rotation + deg2rad(90.0)
