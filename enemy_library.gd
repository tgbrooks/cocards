class_name ObjectiveLibrary extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func make_objective_by_name(objective_name: String, main: Main) -> Objective:
	var objective = Objective.new()
	objective.objective_name = objective_name
	if objective_name == 'grind':
		objective.heat_cost = 0
		objective.oil_cost = 2
		objective.work_cost = 1
	elif objective_name == 'mash':
		objective.heat_cost = 2
		objective.oil_cost = 1
		objective.work_cost = 1
	elif objective_name == 'stir':
		objective.heat_cost = 2
		objective.work_cost = 2
	else:
		print("Unrecognized objective name", objective_name)
		return null
	return objective
