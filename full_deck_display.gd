class_name FullDeckDisplay extends Node2D

var state: GameState
var data_to_card: Dictionary[CardData, Card] = {}
var card_scene = preload("res://card.tscn")
var deck_cards: Array[Card] = []
var upgrades_available: Array[CardUpgrade] = []
var data_to_upgrade: Dictionary[CardUpgradeData, CardUpgrade]
var selected_upgrade: CardUpgradeData
@onready var card_area: Node2D = $CardArea
@onready var upgrade_area: Node2D = $UpgradeArea
@onready var okay_button: Button = $OkayButton

func _ready() -> void:
	var must_init = false
	if state == null:
		must_init = true
		state = GameState.new()

	state.card_made.connect(_on_card_made)
	state.upgrade_gained.connect(_on_upgrade_available)
	state.card_changed.connect(_on_card_changed)

	if must_init:
		state.init()
		state.gain_upgrade(CardUpgradeLibrary.make_card_upgrade("double_damage"))


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
	
	var pos = 0
	var SPACING = 10
	for upgrade in upgrades_available:
		upgrade.position = Vector2(pos, 0)
		pos += upgrade.size.x + SPACING

func _make_card(data: CardData) -> Card:
	var card = card_scene.instantiate()
	card.data = data
	data_to_card[data] = card
	card.pressed.connect(_on_card_pressed.bind(data))
	return card

func lookup_card(data: CardData) -> Card:
	return data_to_card[data]

func _on_card_made(data: CardData):
	var card = _make_card(data)
	card_area.add_child(card)
	deck_cards.append(card)

func _on_upgrade_available(upgrade: CardUpgradeData):
	var upgrade_icon = CardUpgrade.new()
	upgrade_icon.data = upgrade
	upgrade_icon.pressed.connect(_on_upgrade_pressed.bind(upgrade))
	upgrade_area.add_child(upgrade_icon)
	upgrades_available.append(upgrade_icon)
	data_to_upgrade[upgrade] = upgrade_icon

func choose_upgrades():
	await okay_button.pressed

func _on_upgrade_pressed(upgrade:CardUpgradeData):
	if selected_upgrade:
		data_to_upgrade[selected_upgrade].unselect()
	selected_upgrade = upgrade
	data_to_upgrade[upgrade].select()

func _on_card_pressed(card: CardData):
	if selected_upgrade:
		state.apply_upgrade(selected_upgrade, card)

func _on_card_changed(card_data: CardData):
	var card = data_to_card[card_data]
	card.trigger_change()
