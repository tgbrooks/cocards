class_name CardUpgrade extends Button

var data: CardUpgradeData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = data.upgrade_name

func select():
	scale = Vector2(1.2, 1.2)

func unselect():
	scale = Vector2(1.0, 1.0)
