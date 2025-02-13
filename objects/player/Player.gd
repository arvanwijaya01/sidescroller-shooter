extends KinematicBody2D

enum Equip{None, Pistol}
export var have_pistol = true
var mouse_position = Vector2.ZERO
var move_vec = Vector2.ZERO
var equipped = Equip.None
onready var pistol = $Pistol
onready var skeleton = $PlayerSkeleton
onready var animation_player = $PlayerSkeleton/AnimationPlayer
onready var arm_animation_player = $PlayerSkeleton/ArmAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	# Get mouse position and face toward it
	mouse_position = get_global_mouse_position()
	if mouse_position.x > position.x:
		skeleton.scale = Vector2(1.0, 1.0)
		pistol.scale = Vector2(1.0, 1.0)
	elif mouse_position.x < position.x:
		skeleton.scale = Vector2(-1.0, 1.0)
		pistol.scale = Vector2(-1.0, 1.0)
	# Change Equip
	if equipped == Equip.Pistol:
		skeleton.attach_to_front_arm(pistol)
	if Input.is_action_just_pressed("unequip") and equipped != Equip.None:
		arm_animation_player.play("Idle")
		equipped = Equip.None
		pistol.visible = false
	if Input.is_action_just_pressed("equip_pistol") and equipped != Equip.Pistol:
		equipped = Equip.Pistol
		skeleton.attach_to_front_arm(pistol)
		pistol.visible = true
	# Use gun
	match equipped:
		Equip.Pistol:
			if Input.is_action_pressed("aim") and arm_animation_player.current_animation != "PistolReload":
				arm_animation_player.play("PistolAim")
				skeleton.aiming_is_active = true
				if Input.is_action_just_pressed("shoot"):
					pistol.shoot()
			else:
				if arm_animation_player.current_animation != "PistolReload":
					arm_animation_player.play("PistolIdle")
				skeleton.aiming_is_active = false
			if Input.is_action_just_pressed("reload"):
				if pistol.reload():
					arm_animation_player.play("PistolReload")
	# Movement
	var move = movement()
	if animation_player.current_animation != move and is_on_floor():
		if animation_player.current_animation == "Jump":
			skeleton.play_footstep_audio()
		animation_player.play(move)
		if equipped == Equip.None:
			arm_animation_player.play(move)
	# Jump
	if jump():
		animation_player.play("Jump")
		if equipped == Equip.None:
			arm_animation_player.play("Jump")

func movement():
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	var target_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if abs(int(target_dir + skeleton.scale.x)) == 2:
		if !Input.is_action_pressed("run"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -138, 138)
			return "RunForward"
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -60, 60)
			return "WalkForward"
	elif abs(int(target_dir + skeleton.scale.x)) == 0:
		if !Input.is_action_pressed("run"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -90, 90)
			return "RunBackward"
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -40, 40)
			return "WalkBackward"
	else:
		move_vec.x = lerp(move_vec.x, 0, 0.2)
		return "Idle"

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_vec.y = -275
		return true
	return false
