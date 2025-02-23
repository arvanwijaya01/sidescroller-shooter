extends KinematicBody2D

var move_vec = Vector2.ZERO
var is_dead = false
var player = null
var alert = false
onready var skeleton = $ZombieSkeleton
onready var animation_player = $ZombieSkeleton/AnimationPlayer
onready var line_of_sight = $LineOfSight

func _ready():
	randomize()
	animation_player.play("Idle")
	animation_player.seek(rand_range(0.0, 1.0))
	animation_player.set_speed_scale(rand_range(1.0, 2.0))
	player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player").size() > 0 else null

func _physics_process(_delta):
	if player != null:
		line_of_sight.rotation = get_angle_to(player.global_position)
		if line_of_sight.is_colliding():
			alert = true
		if alert:
			animation_player.play("Walk")
			var target_dir = 1 if player.global_position.x > global_position.x else -1
			skeleton.scale.x = target_dir
			move_vec.x = clamp(move_vec.x + target_dir * 15, -28 * animation_player.playback_speed, 28 * animation_player.playback_speed)
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	if is_dead:
		queue_free()

func _on_ZombieSkeleton_died():
	is_dead = true
