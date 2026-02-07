class_name Objective extends Button

@export var objective_name: String = "my_objective"
@export var oil_cost: int = 0
@export var heat_cost: int = 0
@export var work_cost: int = 0
signal completed()
signal ongoing()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resources = Util.format_resources(heat_cost, oil_cost, work_cost)
	text = "%s\n%s" % [objective_name, resources]
	completed.connect(_on_completed)


func _on_completed() -> void:
	print("Completed: ", objective_name)
