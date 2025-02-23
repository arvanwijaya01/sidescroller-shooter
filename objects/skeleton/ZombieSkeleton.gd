extends Node2D

export var health = 30
export var is_climbing = false
signal hurt()
signal died()

func _on_KinematicBody2D_received_damage(damage):
	health -= damage
	emit_signal("hurt")
	if health <= 0:
		emit_signal("died")
