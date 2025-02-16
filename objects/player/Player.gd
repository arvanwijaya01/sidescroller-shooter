extends KinematicBody2D

var mouse_position = Vector2.ZERO
var move_vec = Vector2.ZERO
var is_crouching = false
var can_uncrouch = true
onready var weapon = $Weapon
onready var skeleton = $PlayerSkeleton
onready var animation_player = $PlayerSkeleton/AnimationPlayer
onready var arm_animation_player = $PlayerSkeleton/ArmAnimationPlayer
onready var top_collision_shape = $TopCollisionShape
onready var uncrouch_detection = $UncrouchDetection
onready var climb_detection = $ClimbDetection
onready var tween = $Tween


func _physics_process(_delta):
	# Get mouse position and face toward it
	orientation()
	# Change Equip
	change_equip()
	# Use gun
	if skeleton.is_climbing:
		skeleton.aiming_is_active = false
	else:
		if weapon.equipped != weapon.Equip.None:
			use_weapon()
	# Climb
	if climb():
		return
	# Movement
	var move = movement()
	if (animation_player.current_animation != move and is_on_floor()) or skeleton.is_dodging:
		if animation_player.current_animation == "Jump":
			skeleton.play_footstep_audio()
		animation_player.play(move)
		if weapon.equipped == weapon.Equip.None:
			arm_animation_player.play(move)
	# Jump
	if jump() or (!is_on_floor() and !skeleton.is_dodging):
		animation_player.play("Jump")
		if weapon.equipped == weapon.Equip.None:
			arm_animation_player.play("Jump")

func orientation():
	if !skeleton.is_climbing:
		mouse_position = get_global_mouse_position()
		if mouse_position.x > position.x:
			skeleton.scale = Vector2(1.0, 1.0)
			weapon.scale = Vector2(1.0, 1.0)
			climb_detection.scale = Vector2(1.0, 1.0)
		elif mouse_position.x < position.x:
			skeleton.scale = Vector2(-1.0, 1.0)
			weapon.scale = Vector2(-1.0, 1.0)
			climb_detection.scale = Vector2(-1.0, 1.0)

func change_equip():
	if weapon.equipped == weapon.Equip.None:
		skeleton.aiming_is_active = false
	else:
		skeleton.attach_to_front_arm(weapon)
	if Input.is_action_just_pressed("unequip") and weapon.equipped != weapon.Equip.None:
		arm_animation_player.play(animation_player.current_animation)
		arm_animation_player.seek(animation_player.current_animation_position)
		weapon.equipped = weapon.Equip.None
	if Input.is_action_just_pressed("equip_pistol") and weapon.equipped != weapon.Equip.Pistol:
		weapon.equipped = weapon.Equip.Pistol

func use_weapon():
	if arm_animation_player.current_animation != weapon.get_equipped_name() + "Reload":
		arm_animation_player.play(weapon.get_equipped_name() + "Aim")
		skeleton.aiming_is_active = true
		if Input.is_action_pressed("shoot"):
			weapon.shoot()
	else:
		skeleton.aiming_is_active = false
	if Input.is_action_just_pressed("reload"):
		if weapon.reload():
			arm_animation_player.play(weapon.get_equipped_name() + "Reload")

func climb():
	if skeleton.is_climbing:
		return true
	else:
		var target_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		if climb_detection.can_climb and abs(int(target_dir + skeleton.scale.x)) == 2 and !is_on_floor():
			if skeleton.is_dodging:
				skeleton.is_dodging = false
			position = climb_detection.corner_position + Vector2(skeleton.scale.x * -14.0, 33)
			tween.interpolate_property(self, "position",
					position, climb_detection.corner_position + Vector2(skeleton.scale.x * 14.0, -33), 0.6,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			move_vec = Vector2.ZERO
			animation_player.play("Climb")
			arm_animation_player.play("Climb")
			return true
	return false

func movement():
	if (Input.is_action_pressed("crouch") and is_on_floor()) or (is_crouching and uncrouch_detection.is_colliding()) or (is_crouching and skeleton.is_dodging):
		is_crouching = true
		top_collision_shape.disabled = true
		if Input.is_action_just_pressed("dodge") and !skeleton.is_dodging:
			move_vec.x = skeleton.scale.x * 400.0
			skeleton.is_dodging = true
			return "Slide"
	else:
		is_crouching = false
		top_collision_shape.disabled = false
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	if skeleton.is_dodging:
		return animation_player.current_animation
	var target_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if abs(int(target_dir + skeleton.scale.x)) == 2:
		if Input.is_action_just_pressed("dodge"):
			move_vec.x = skeleton.scale.x * 400.0
			skeleton.is_dodging = true
			return "DodgeForward"
		elif is_crouching:
			move_vec.x = lerp(move_vec.x, 0, 0.2)
			return "Crouch"
		elif !Input.is_action_pressed("walk"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -138, 138)
			return "RunForward"
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -60, 60)
			return "WalkForward"
	elif abs(int(target_dir + skeleton.scale.x)) == 0:
		if Input.is_action_just_pressed("dodge"):
			move_vec.x = -skeleton.scale.x * 400.0
			skeleton.is_dodging = true
			return "DodgeBackward"
		if is_crouching:
			move_vec.x = lerp(move_vec.x, 0, 0.2)
			return "Crouch"
		elif !Input.is_action_pressed("walk"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -90, 90)
			return "RunBackward"
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -40, 40)
			return "WalkBackward"
	else:
		if is_crouching:
			move_vec.x = lerp(move_vec.x, 0, 0.2)
			return "Crouch"
		else:
			move_vec.x = lerp(move_vec.x, 0, 0.2)
			return "Idle"

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_uncrouch and !skeleton.is_dodging:
		move_vec.y = -275
		return true
	return false
