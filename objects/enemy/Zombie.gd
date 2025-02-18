extends KinematicBody2D


var move_vec = Vector2.ZERO


func _physics_process(_delta):
	move_vec = move_and_slide(move_vec, Vector2.UP)
	move_vec.y += 10
