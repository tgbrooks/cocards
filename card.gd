class_name Card extends Button

@export var card_name: String = "mycard"
@export var work: int = 0
@export var heat: int = 0
@export var oil: int = 0
@export var face_up: bool = true
signal card_flipped(to_front: bool)
signal played(enemy: Enemy)
var card_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resources = Util.format_resources(heat, oil, work)
	card_text = "%s\n%s" % [card_name, resources]
	if face_up:
		text = card_text

func _on_pressed() -> void:
	get_parent().card_selected.emit(self)

func select() -> void:
	add_theme_font_size_override("font_size", 20)

func unselect() -> void:
	add_theme_font_size_override("font_size", 16)

func flip_card(to_front: bool) -> void:
	card_flipped.emit(to_front)
	if to_front:
		text = card_text
	else:
		text = "--"
