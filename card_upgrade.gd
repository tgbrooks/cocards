class_name CardUpgrade extends Node

@export var upgrade_name: String = "upgrade"
@export var damage: int = 0
@export var dodge: int = 0
@export var shield: int = 0
@export var description: String = "MISSING"
@export var labels: Array[String] = []

var first_pass = func(result: StackResults, _enemy: Enemy, _main: Main, _cards: Array[Card]) -> StackResults:
	result.damage += damage
	result.shield += shield
	result.dodge += dodge
	return result

var second_pass = func(result: StackResults, _enemy: Enemy, _main: Main, _cards: Array[Card]) -> StackResults:
	return result
