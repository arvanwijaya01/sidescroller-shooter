extends KinematicBody2D

var move_vec = Vector2.ZERO
var random_speed = 1.0
var is_dead = false
var player = null
var alert = false
onready var skeleton = $ZombieSkeleton
onready var animation_player = $ZombieSkeleton/AnimationPlayer
onready var line_of_sight = $LineOfSight
onready var climb_detection = $ClimbDetection
onready var tween = $Tween

func _ready():
	randomize()
	random_speed = rand_range(1.0, 2.0)
	animation_player.play("Idle")
	animation_player.seek(rand_range(0.0, 1.0))
	player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player").size() > 0 else null

func _physics_process(_delta):
	if animation_player.current_animation == "Walk":
		animation_player.set_speed_scale(random_speed)
	else:
		animation_player.set_speed_scale(1.0)
	if player != null:
		line_of_sight.rotation = get_angle_to(player.global_position)
		if line_of_sight.is_colliding():
			alert = true
		if alert:
			if skeleton.is_hurting:
				return
			if climb():
				return
			animation_player.play("Walk")
			var target_dir = 1 if player.global_position.x > global_position.x else -1
			skeleton.scale.x = target_dir
			climb_detection.scale.x = target_dir
			move_vec.x = clamp(move_vec.x + target_dir * 15, -28 * animation_player.playback_speed, 28 * animation_player.playback_speed)
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	if is_dead:
		queue_free()

func climb():
	if skeleton.is_climbing:
		return true
	else:
		if climb_detection.can_climb:
			position = climb_detection.corner_position + Vector2(skeleton.scale.x * -14.0, 33)
			tween.interpolate_property(self, "position",
					position, climb_detection.corner_position + Vector2(skeleton.scale.x * 14.0, -33), 0.6,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			move_vec = Vector2.ZERO
			skeleton.is_climbing = true
			animation_player.play("Climb")
			return true
	return false

func _on_ZombieSkeleton_died():
	is_dead = true

func _on_ZombieSkeleton_hurt(part):
	alert = true
	if !skeleton.is_climbing and skeleton.health > 0:
		if part == "Leg":
			skeleton.is_hurting = true
			animation_player.play("LegHurt")
			animation_player.seek(0.0)
		elif part == "Head":
			skeleton.is_hurting = true
			animation_player.play("HeadHurt")
			animation_player.seek(0.0)
		else:
			skeleton.is_hurting = true
			animation_player.play("Hurt")
			animation_player.seek(0.0)
