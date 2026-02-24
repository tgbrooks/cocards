class_name Card extends Button

@export var card_name: String = "mycard"
@export var number: int = 0 
@export var suit: Enums.Suit = Enums.Suit.RED
@export var face_up: bool = true
@export var damage: int = 1
signal card_flipped(to_front: bool)
signal played(enemy: Enemy)
var card_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var damage_icons = '⚔️'.repeat(damage)
	card_text = "%s %s\n%s" % [number, card_name, damage_icons]
	if face_up:
		text = card_text
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	get_parent().card_pressed(self)

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

func play(enemy: Enemy) -> void:
	enemy.take_damage(damage)
	get_parent().remove(self)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 0.15).set_ease(Tween.EASE_IN)
	tween.tween_callback(self.queue_free)
	played.emit(enemy)
	
static func can_chain(cards: Array[Card]) -> bool:
	var curr_number = null
	for card in cards:
		if curr_number == null:
			curr_number = card.number
			continue
		if card.number != curr_number -1:
			return false
		curr_number = card.number
	return true
