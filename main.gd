class_name Main extends Node2D

var selected_card = null
var played_cards: Array[CardStack] = []
var enemies: Array[Enemy] = []
var player_health: int = 10
var player_charges: int = 0
var player_coins: int = 0
@onready var health_text:Label = $HealthText
@onready var charges_text:Label = $ChargesText
@onready var coins_text:Label = $CoinsText

signal players_damaged(damage: int)
signal gain_charges(num_charges: int)
signal gain_coins(num_coins: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Hand").make_deck(self)
	get_node("Hand").deal_hand()
	players_damaged.connect(func(dmg): player_health -= dmg)
	players_damaged.connect(func(dmg): update_health())
	gain_charges.connect(func(num): player_charges += num)
	gain_charges.connect(func(num): update_charges())
	gain_coins.connect(func(num): player_coins += num)
	gain_coins.connect(func(num): update_coins())
	update_health()
	update_charges()
	update_coins()

	var enemy_lib = EnemyLibrary.new()
	var enemy_names = ['grunt', 'slime', 'mage']
	for i in range(enemy_names.size()):
		var enemy_name = enemy_names[i]
		var enemy = enemy_lib.make_enemy_by_name(enemy_name, self)
		enemy.pressed.connect(func (): play_card(enemy, get_node("Hand").selected_card))
		enemy.position = Vector2(i * 200, 200)
		var cs = CardStack.new()
		cs.reference = enemy
		played_cards.append(cs)
		add_child(enemy)
		add_child(cs)
		enemies.append(enemy)

func play_card(enemy, card):
	if card:
		var eidx = enemies.find(enemy)
		played_cards[eidx].append(card)
		card.unselect()
		get_node('Hand').selected_card = null
		card.played.emit(enemy)

func sum(accum, x):
	return accum + x
	
func update_health():
	health_text.text = "Health: %s" % player_health
	
func update_coins():
	coins_text.text = "Coins: %s" % player_coins
	
func update_charges():
	charges_text.text = "Charges: %s" % player_charges


func end_turn() -> void:
	for i in range(enemies.size()):
		var enemy = enemies[i]
		var cs = played_cards[i]
		var tot_damage = cs.cards.map(func(c): return c.attack).reduce(sum, 0)
		var tot_defense = cs.cards.map(func(c): return c.defense).reduce(sum, 0)
		print("Resolving %s: %s %s" % [enemy.enemy_name, tot_damage, tot_defense])
		if tot_damage >= enemy.health:
			enemy.defeated.emit()
		else:
			enemy.survived.emit()
		if tot_defense < enemy.attack:
			players_damaged.emit(enemy.attack - tot_defense)


func _on_end_turn_button_pressed() -> void:
	end_turn()
