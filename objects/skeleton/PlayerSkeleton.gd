extends Node2D

export var is_dodging = false
export var is_climbing = false
var aiming_is_active = false setget set_aiming_is_active
onready var front_hand = $BottomTorso/MidTorso/TopTorso/FrontArmNode/FrontArm/LowerArm/Hand
onready var back_hand = $BottomTorso/MidTorso/TopTorso/BackArmNode/BackArm/LowerArm/Hand
onready var head_node = $BottomTorso/MidTorso/TopTorso/HeadNode
onready var back_arm_node = $BottomTorso/MidTorso/TopTorso/BackArmNode
onready var front_arm_node = $BottomTorso/MidTorso/TopTorso/FrontArmNode
onready var top_torso = $BottomTorso/MidTorso/TopTorso
onready var mid_torso = $BottomTorso/MidTorso
onready var bottom_torso = $BottomTorso
onready var tween = $Tween
onready var footstep_audio = $FootstepAudio
onready var front_arm_equip = $BottomTorso/MidTorso/TopTorso/FrontArmNode/FrontArm/LowerArm/Hand/Equip

func _physics_process(_delta):
	if aiming_is_active:
		var arm_target_rotation = front_arm_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		arm_target_rotation = get_global_mouse_position().angle_to_point(front_arm_node.global_position + (Vector2(0.0, -6.5)).rotated(scale.x * arm_target_rotation))
		arm_target_rotation = arm_target_rotation if scale.x > 0 else deg2rad(180.0) - arm_target_rotation
		arm_target_rotation -= top_torso.rotation + mid_torso.rotation + bottom_torso.rotation
		var head_target_rotation = head_node.position.angle_to(get_local_mouse_position()) + deg2rad(-90.0)
		head_node.rotation = clamp(lerp_angle(head_node.rotation, head_target_rotation, 0.5), deg2rad(-45.0), deg2rad(45.0))
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
	front_arm_equip.remote_path = front_arm_equip.get_path_to(obj)
