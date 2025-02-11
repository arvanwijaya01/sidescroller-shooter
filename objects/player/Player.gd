extends KinematicBody2D

enum Equip{None, Pistol}
export var have_pistol = true
var mouse_position = Vector2.ZERO
var move_vec = Vector2.ZERO
var equipped = Equip.None
onready var pistol = $Pistol
onready var skeleton = $HumanSkeleton
onready var animation_player = $HumanSkeleton/AnimationPlayer
onready var arm_animation_player = $HumanSkeleton/ArmAnimationPlayer

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
		equipped = Equip.None
		pistol.visible = false
	if Input.is_action_just_pressed("equip_pistol") and equipped != Equip.Pistol:
		equipped = Equip.Pistol
		skeleton.attach_to_front_arm(pistol)
		pistol.visible = true
	# Movement
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	var target_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if abs(int(target_dir + skeleton.scale.x)) == 2:
		if !Input.is_action_pressed("run"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -138, 138)
			if animation_player.current_animation != "RunForward" and is_on_floor():
				animation_player.play("RunForward")
				match equipped:
					Equip.None:
						arm_animation_player.play("RunForward")
					Equip.Pistol:
						arm_animation_player.play("PistolRun")
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -60, 60)
			if animation_player.current_animation != "WalkForward" and is_on_floor():
				animation_player.play("WalkForward")
				match equipped:
					Equip.None:
						arm_animation_player.play("WalkForward")
					Equip.Pistol:
						arm_animation_player.play("PistolWalk")
	elif abs(int(target_dir + skeleton.scale.x)) == 0:
		if !Input.is_action_pressed("run"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -90, 90)
			if animation_player.current_animation != "RunBackward" and is_on_floor():
				animation_player.play("RunBackward")
				match equipped:
					Equip.None:
						arm_animation_player.play("RunBackward")
					Equip.Pistol:
						arm_animation_player.play("PistolRun")
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -40, 40)
			if animation_player.current_animation != "WalkBackward" and is_on_floor():
				animation_player.play("WalkBackward")
				match equipped:
					Equip.None:
						arm_animation_player.play("WalkBackward")
					Equip.Pistol:
						arm_animation_player.play("PistolWalk")
	else:
		if animation_player.current_animation != "Idle" and is_on_floor():
			animation_player.play("Idle")
			match equipped:
				Equip.None:
					arm_animation_player.play("Idle")
				Equip.Pistol:
					arm_animation_player.play("PistolIdle")
	if !is_on_floor():
		if animation_player.current_animation != "Jump":
			animation_player.play("Jump")
			match equipped:
				Equip.None:
					arm_animation_player.play("Jump")
				Equip.Pistol:
					arm_animation_player.play("PistolJump")
	if target_dir == 0:
		move_vec.x = lerp(move_vec.x, 0, 0.2)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_vec.y = -275
	
