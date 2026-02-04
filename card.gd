class_name Card extends Button

@export var card_name: String = "mycard"
@export var attack: int = 0
@export var defense: int = 0
signal played(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	text = "%s\n%s/%s" % [card_name, attack, defense]

func _on_pressed() -> void:
	get_parent().card_selected.emit(self)

func select() -> void:
	self.add_theme_font_size_override("font_size", 20)

func unselect() -> void:
	self.add_theme_font_size_override("font_size", 16)
