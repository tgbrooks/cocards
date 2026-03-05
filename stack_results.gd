class_name StackResults extends Node
var preview_scene = preload("res://stack_result_preview.tscn")


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

func preview() -> StackResultPreview:
	var srp = preview_scene.instantiate()
	srp.stack_results = self
	return srp
