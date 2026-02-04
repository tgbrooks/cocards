class_name Enemy extends Button

@export var enemy_name: String = "myenemy"
@export var attack: int = 0
@export var health: int = 1
signal defeated()
signal survived()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "%s\n%s/%s" % [enemy_name, attack, health]
	defeated.connect(_on_defeated)


func _on_defeated() -> void:
	print("Defeated a ", enemy_name)
