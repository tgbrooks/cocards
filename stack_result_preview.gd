class_name StackResultPreview extends Node2D


var stack_results: StackResults
@onready var label: Label = $Label

func _ready() -> void:
	var damage_icons = '⚔️'.repeat(stack_results.damage)
	var shield_icons = '🛡️'.repeat(stack_results.shield)
	var dodge_icons = '🏃'.repeat(stack_results.dodge)
	label.text = "%s\n%s\n%s" % [damage_icons, shield_icons, dodge_icons]
