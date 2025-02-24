extends KinematicBody2D

export var damage_multiplier = 1.0
export var bodypart = "Normal"
signal received_damage(damage, part)

func apply_damage(damage : float):
	emit_signal("received_damage", damage * damage_multiplier, bodypart)
