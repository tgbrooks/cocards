class_name Card extends Button

@export var card_name: String = "mycard"
@export var work: int = 0
@export var heat: int = 0
@export var oil: int = 0
signal played(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resources = Util.format_resources(heat, oil, work)
	text = "%s\n%s" % [card_name, resources]

func _on_pressed() -> void:
	get_parent().card_selected.emit(self)

func select() -> void:
	self.add_theme_font_size_override("font_size", 20)

func unselect() -> void:
	self.add_theme_font_size_override("font_size", 16)
