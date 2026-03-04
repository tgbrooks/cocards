class_name StackResults extends Node

var damage = 0
var shield = 0
var dodge = 0

func apply(cards: Array[Card], enemy: Enemy, main: Main) -> void:
	if damage > 0:
		enemy.take_damage(damage)
	if shield > 0:
		main.gain_shield(shield)
	if dodge > 0:
		enemy.gain_dodge(dodge)
