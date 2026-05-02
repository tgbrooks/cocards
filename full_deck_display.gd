class_name FullDeckDisplay extends Node2D

var state: GameState
var data_to_card: Dictionary[CardData, Card] = {}
var card_scene = preload("res://card.tscn")
var deck_cards: Array[Card] = []
@onready var card_area: Node2D = $CardArea

func _ready() -> void:
	var must_init = false
	if state == null:
		must_init = true
		state = GameState.new()

	state.card_made.connect(_on_card_made)

	if must_init:
		state.init()

func _process(_delta: float):
	var i = 0
	var num_cols = 5
	var col_width = 150
	var vert_spacing = 190
	for card in deck_cards:
		var col = i % num_cols
		@warning_ignore("integer_division")
		var row = i / num_cols
		card.position = Vector2(col*col_width, row*vert_spacing)
		i += 1

func _make_card(data: CardData) -> Card:
	var card = card_scene.instantiate()
	card.data = data
	data_to_card[data] = card
	return card

func lookup_card(data: CardData) -> Card:
	return data_to_card[data]

func _on_card_made(data: CardData):
	var card = _make_card(data)
	card_area.add_child(card)
	deck_cards.append(card)
