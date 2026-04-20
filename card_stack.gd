class_name CardStack extends Node2D
@export var BETWEEN_CARD_HEIGHT: int = 50

var cards: Array[Card]:
	get():
		var my_cards: Array[Card] = []
		for node in get_children():
			if node is Card:
				my_cards.append(node)
		return my_cards

var padding: float = 10.0
@onready var background_button: Button = $BackgroundButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_button.pressed.connect(stack_pressed)


func append(card: Card) -> void:
	var curr_height: int = 0
	for child in get_children():
		if not child is Card:
			continue
		curr_height += BETWEEN_CARD_HEIGHT

	var old_pos = card.global_position
	var parent = card.get_parent()
	if parent:
		parent.remove_child(card)
	add_child(card)
	
	var to_pos: Vector2 = Vector2(0, curr_height)

	if old_pos == Vector2.ZERO:
		card.position = to_pos
	else:
		card.position = to_local(old_pos)
		await AnimThread.await_anim_okay()
		var tween: Tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(card, "position", to_pos, 0.2)
		AnimThread.make_blocking_anim_tween(tween)


func remove(card: Card):
	remove_child(card)

func card_pressed(card: Card) -> void:
	var idx = cards.find(card)
	if idx == -1:
		print("ERROR: Selecting from the wrong card stack")
		return
	var these_cards = cards.slice(idx)
	if not Card.can_chain(these_cards):
		return
	get_parent().cards_activated(these_cards, self)

func stack_pressed() -> void:
	if cards:
		# There is a card here so we act like we click on the card
		var bottom_card = cards[cards.size()-1]
		card_pressed(bottom_card)
	else:
		# Empty cards activated onto here to move any selected cards to us
		var empty: Array[Card] = []
		get_parent().cards_activated(empty, self)
