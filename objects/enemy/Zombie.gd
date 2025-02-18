extends KinematicBody2D

var move_vec = Vector2.ZERO
var is_dead = false
onready var skeleton = $ZombieSkeleton
onready var animation_player = $ZombieSkeleton/AnimationPlayer

func _physics_process(_delta):
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
	animation_player.play("Idle")
	if is_dead:
		queue_free()


func _on_ZombieSkeleton_died():
	is_dead = true
