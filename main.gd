class_name Main extends Node2D

@export var player_health: int = 20
@export var selected_cards: Array[Card] = []
@export var selected_card_stack: CardStack = null
@export var played_cards: Array[CardStack] = []
@export var objectives: Array[Objective] = []
@export var active_player: String = "human"
@export var enemy_action_points: int = 0
@export var enemy_action_points_threshold: int = 3
var card_stacks: Array[CardStack] = []
var deck: Array[Card] = []
signal enemy_action_points_changed(old_value: int, new_value: int)
signal enemy_action_taken()
signal player_damaged(old_health: int, new_health: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var cs = CardStack.new()
		card_stacks.append(cs)
		cs.position = Vector2(200*i+100, 300)
		self.add_child(cs)
		
	var library = CardLibrary.new()
	for card_name in ["one", "one", "one", "two", "two", "two", "three", "three", "three", "chain_strike"]:
		var card = library.make_card_by_name(card_name, self)
		deck.append(card)
		self.add_child(card)

	deck.shuffle()

	var i = 0
	while true:
		var card = deck.pop_back()
		if not card:
			break
		card_stacks[i].append(card)
		i = (i + 1) % card_stacks.size()

	$EnemyArea.spawn_enemies()
	enemy_action_points_changed.connect(_on_enemy_action_points_changed)
	player_damaged.connect(_on_player_damaged)
	player_damaged.emit(player_health, player_health)

func _on_go_button_pressed() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		# FOR DEBUG PURPOSES, RESTART GAME
		get_tree().reload_current_scene()

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
		for i in range(selected_cards.size()-1,-1,-1):
			var card = selected_cards[i]
			play_card(card, enemy, selected_cards)
		gain_enemy_action_points(1)
		selected_cards = []
		selected_card_stack = null

func play_card(card: Card, enemy: Enemy, card_stack: Array[Card]) -> void:
	card.play(enemy, card_stack)
	var idx = selected_cards.find(card)
	if idx >= 0:
		selected_cards.pop_at(idx)

func gain_enemy_action_points(points:int) -> void:
	var old = enemy_action_points
	enemy_action_points += points
	enemy_action_points_changed.emit(old, enemy_action_points)
	if enemy_action_points >= enemy_action_points_threshold:
		old = enemy_action_points
		enemy_action_points = 0
		enemy_action_taken.emit()
		enemy_action_points_changed.emit(old, enemy_action_points)

func _on_enemy_action_points_changed(old, new) -> void:
	$EnemyActions.text = "Action points: %s" % new

func damage_player(damage: int) -> void:
	var old = player_health
	player_health -= damage
	player_damaged.emit(old, player_health)

func _on_player_damaged(old, new) -> void:
	$PlayerHealthText.text = "Player health: %s" % new
