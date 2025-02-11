extends KinematicBody2D

var mouse_position = Vector2.ZERO
var move_vec = Vector2.ZERO
onready var skeleton = $HumanSkeleton
onready var animation_player = $HumanSkeleton/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	mouse_position = get_global_mouse_position()
	if mouse_position.x > position.x:
		skeleton.scale = Vector2(1.0, 1.0)
	elif mouse_position.x < position.x:
		skeleton.scale = Vector2(-1.0, 1.0)
	# Movement
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	var target_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if abs(int(target_dir + skeleton.scale.x)) == 2:
		if !Input.is_action_pressed("run"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -138, 138)
			if animation_player.current_animation != "RunForward":
				animation_player.play("RunForward")
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -60, 60)
			if animation_player.current_animation != "WalkForward":
				animation_player.play("WalkForward")
	elif abs(int(target_dir + skeleton.scale.x)) == 0:
		if !Input.is_action_pressed("run"):
			move_vec.x = clamp(move_vec.x + target_dir * 15, -90, 90)
			if animation_player.current_animation != "RunBackward":
				animation_player.play("RunBackward")
		else:
			move_vec.x = clamp(move_vec.x + target_dir * 15, -40, 40)
			if animation_player.current_animation != "WalkBackward":
				animation_player.play("WalkBackward")
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")
	if target_dir == 0:
		move_vec.x = lerp(move_vec.x, 0, 0.2)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_vec.y = -512
	
