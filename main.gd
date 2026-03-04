class_name Main extends Node2D

@export var player_health: int = 20
@export var selected_cards: Array[Card] = []
@export var selected_card_stack: CardStack = null
@export var played_cards: Array[CardStack] = []
@export var objectives: Array[Objective] = []
@export var active_player: String = "human"
@export var player_shield: int = 0
var card_stacks: Array[CardStack] = []
signal player_damaged(old_health: int, new_health: int)
signal player_shield_changed(old: int, new: int)
@onready var enemy_area: EnemyArea = $EnemyArea
@onready var player_health_label: Label = $PlayerHealthLabel
@onready var player_shield_label: Label = $PlayerShieldLabel
@onready var deck: Deck = $Deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var cs = CardStack.new()
		card_stacks.append(cs)
		cs.position = Vector2(200*i+100, 300)
		self.add_child(cs)
		
	var library = CardLibrary.new()
	for card_name in ["one", "one", "two", "two",  "three", "three",  "chain_strike", "red twin", "blue twin", "green twin", "double_dmg"]:
		var card = library.make_card_by_name(card_name, self)
		deck.append(card)

	deal_cards()

	enemy_area.spawn_enemies()
	player_damaged.connect(_on_player_damaged)
	player_damaged.emit(player_health, player_health)
	player_shield_changed.connect(_on_player_shield_change)
	player_shield_changed.emit(0,0)

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		# FOR DEBUG PURPOSES, RESTART GAME
		get_tree().reload_current_scene()

func deal_cards():
	deck.shuffle()

	var i = 0
	while true:
		var card = deck.pop()
		if not card:
			break
		card.flip_card(Enums.CardFace.FRONT)
		card_stacks[i].append(card)
		i = (i + 1) % card_stacks.size()

func cards_activated(cards: Array[Card], card_stack: CardStack) -> void:
	if not Card.can_chain(cards):
		return
	if selected_card_stack != card_stack and selected_cards.size() > 0:
		# Try playing the cards from the old stack onto the newly clicked stack
		var bottom_card = cards[cards.size()-1]
		var top_card = selected_cards[0]
		if top_card.number == bottom_card.number - 1:
			# move the cards onto the new stack
			for card in selected_cards:
				card.unselect()
				card_stack.append(card)
			selected_card_stack = null
			selected_cards = []
			return

	for card in selected_cards:
		card.unselect()
	selected_cards = cards
	for card in selected_cards:
		card.select()
	selected_card_stack = card_stack

func on_enemy_pressed(enemy: Enemy) -> void:
	if selected_cards:
		# Play selected cards on the enemy, starting from the bottom
		var chain = selected_cards.duplicate(false)

		var result = Card.compute_chain(selected_cards, enemy, self)
		result.apply(chain, enemy, self)
		for i in range(chain.size()-1,-1,-1):
			var card = chain[i]
			card.unselect()
			play_card(card)
		gain_enemy_action_points(1)
		selected_cards = []
		selected_card_stack = null

		var all_empty = true
		for cs in card_stacks:
			if cs.cards.size() > 0:
				all_empty = false
		if all_empty:
			deal_cards()

func play_card(card: Card) -> void:
	card.get_parent().remove(card)
	var idx = selected_cards.find(card)
	if idx >= 0:
		selected_cards.pop_at(idx)
	deck.append(card)
	await card.flip_card(Enums.CardFace.BACK)


func gain_enemy_action_points(points:int) -> void:
	enemy_area.gain_action_points(points)

func damage_player(damage: int) -> void:
	var old = player_health
	var blocked_damage = min(damage, player_shield)
	var unblocked_damage = damage - blocked_damage
	player_health -= unblocked_damage
	if player_health != old:
		player_damaged.emit(old, player_health)
	if blocked_damage > 0:
		var old_shield = player_shield
		player_shield -= blocked_damage
		player_shield_changed.emit(old_shield, player_shield)

func gain_shield(shield: int) -> void:
	var old = player_shield
	player_shield += shield
	player_shield_changed.emit(old, player_shield)

func _on_player_damaged(_old, new) -> void:
	player_health_label.text = "Player health: %s" % new

func _on_player_shield_change(_old, new) -> void:
	player_shield_label.text = 'Player shield: %s🛡️' % new
