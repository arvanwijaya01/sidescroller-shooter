extends KinematicBody2D

export var damage_multiplier = 1.0
signal received_damage(damage)

func apply_damage(damage : float):
	emit_signal("received_damage", damage * damage_multiplier)
