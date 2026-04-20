class_name Main extends Node2D

@export var state: GameState
@export var selected_cards: Array[Card] = []
@export var selected_card_stack: CardStack = null
var card_stacks: Array[CardStack] = []
@onready var enemy_area: EnemyArea = $EnemyArea
@onready var player_health_label: Label = $PlayerHealthLabel
@onready var player_shield_label: Label = $PlayerShieldLabel
@onready var deck: Deck = $Deck
var stack_results_preview: StackResultPreview = null
var cs_scene = preload("res://card_stack.tscn")
var card_scene = preload("res://card.tscn")

var data_to_card: Dictionary[CardData, Card] = {}

func _init() -> void:
	state = GameState.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.data = state.deck
	enemy_area.state = state
	for i in range(3):
		var cs = cs_scene.instantiate()
		card_stacks.append(cs)
		cs.position = Vector2(200*i+100, 300)
		self.add_child(cs)

	state.player_damaged.connect(_on_player_damaged)
	_on_player_damaged(state.player_health, state.player_health)
	state.player_shield_changed.connect(_on_player_shield_change)
	_on_player_shield_change(state.player_shield, state.player_shield)
	state.card_made.connect(_make_card)
	state.card_stacked.connect(_stack_card)
	state.card_played.connect(_on_card_played)
	enemy_area.on_enemy_pressed.connect(_on_enemy_pressed)
	enemy_area.on_enemy_hovered.connect(preview_stack_results)

	state.init()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			# FOR DEBUG PURPOSES, RESTART GAME
			get_tree().reload_current_scene()
			AnimThread.wipe_anim_lock()
		if event.pressed and event.keycode == KEY_W:
			# FOR DEBUG PURPOSES, "WIN" THE ROUND
			for enemy in state.enemies:
				enemy.take_damage(1000)


func cards_activated(cards: Array[Card], card_stack: CardStack) -> void:
	if not Card.can_chain(cards):
		return
	if selected_card_stack != card_stack and selected_cards.size() > 0:
		# Try playing the cards from the old stack onto the newly clicked stack
		var new_chain = cards.duplicate()
		new_chain.append_array(selected_cards)
		var can_chain = Card.can_chain(new_chain)
		if can_chain:
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

func _on_enemy_pressed(enemy: Enemy) -> void:
	if selected_cards:
		# Play selected cards on the enemy, starting from the bottom
		var stack: Array[CardData] = []
		for card in selected_cards:
			stack.append(card.data)
		state.play_stack(stack, enemy.data)
		selected_cards = []
		selected_card_stack = null
		clear_stack_results_preview()

func _on_card_played(card: Card) -> void:
	var idx = selected_cards.find(card)
	if idx >= 0:
		selected_cards.pop_at(idx)
	deck.append(card)
	await card.flip_card(Enums.CardFace.BACK)

func _on_player_damaged(_old, new) -> void:
	player_health_label.text = "Player health: %s" % new

func _on_player_shield_change(_old, new) -> void:
	player_shield_label.text = 'Player shield: %s🛡️' % new

func preview_stack_results(enemy) -> void:
	if selected_cards:
		var res = Card.compute_chain(selected_cards, enemy, self.state)
		var preview = res.preview()
		preview.position = Vector2(100, 100)
		add_child(preview)
		if stack_results_preview:
			stack_results_preview.queue_free()
		stack_results_preview = preview

func clear_stack_results_preview():
	if stack_results_preview:
		stack_results_preview.queue_free()
		stack_results_preview = null

func _make_card(data: CardData):
	var card = card_scene.instantiate()
	card.data = data
	data_to_card[data] = card

func _stack_card(data: CardData, idx: int):
	var card = data_to_card[data]
	var cs = card_stacks[idx]
	cs.append(card)

func lookup_card(data: CardData) -> Card:
	return data_to_card[data]

var player_position: Vector2:
	get():
		return player_health_label.global_position
