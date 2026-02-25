class_name Card extends Node2D

@export var card_name: String = "mycard"
@export var number: int = 0 
@export var suit: Enums.Suit = Enums.Suit.RED
@export var face_up: bool = true
@export var damage: int = 1
@export var description: String = ''
signal card_flipped(to_front: bool)
signal played(enemy: Enemy, card_stack: Array[Card])
var card_text: String
@onready var button: Button = $Button
@onready var number_label: Label = $NumberLabel
@onready var name_label: Label = $NameLabel
@onready var description_label: Label = $DescriptionLabel
@onready var card_sprite: Sprite2D = $CardSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var damage_icons = '⚔️'.repeat(damage)
	number_label.text = "%s" % number
	name_label.text = card_name
	description_label.text = '%s\n%s' % [damage_icons, description]
	self.button.pressed.connect(_on_pressed)
	button.modulate = Color(1.0, 1.0, 1.0, 0.0)

func _on_pressed() -> void:
	get_parent().card_pressed(self)

func select() -> void:
	scale = Vector2(1.2, 1.2)
	
func unselect() -> void:
	scale = Vector2(1.0, 1.0)
	
func flip_card(to_front: bool) -> void:
	card_flipped.emit(to_front)
	if to_front:
		button.text = card_text
	else:
		button.text = "--"

func play(enemy: Enemy, card_stack: Array[Card]) -> void:
	enemy.take_damage(damage)
	get_parent().remove(self)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), 0.15).set_ease(Tween.EASE_IN)
	tween.tween_callback(self.queue_free)
	played.emit(enemy, card_stack)
	
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
