class_name GameState extends Resource

@export var player_health: int = 20
@export var enemies: Array[EnemyData] = []
@export var player_shield: int = 0
@export var deck: DeckData = DeckData.new()
@export var card_stacks: Array
@export var level: int = 0


signal player_damaged(old_health: int, new_health: int)
signal player_shield_changed(old: int, new: int)
signal enemy_made(enemy: EnemyData)
signal card_played(card: CardData)
signal card_stacked(card: CardData, stack_idx: int)
signal card_made(card: CardData)
signal level_cleared()


func _init() -> void:
	card_stacks.append([])
	card_stacks.append([])
	card_stacks.append([])

func init() -> void:
	var library = CardLibrary.new()
	for card_name in ["red one", "green one", "blue one", "red two", "blue two", "green two",  "red three", "blue three", "green three", "chain"]:
		var card = library.make_card_data_by_name(card_name, self)
		card_made.emit(card)
		deck.append(card)
	deal_cards()

	spawn_enemies()
	player_damaged.emit(player_health, player_health)
	player_shield_changed.emit(0,0)

func deal_cards():
	await deck.shuffle()

	var i = 0
	while true:
		var card = await deck.pop()
		if not card:
			break
		card.flip_card(Enums.CardFace.FRONT)
		card_stacks[i].append(card)
		card_stacked.emit(card, i)
		i = (i + 1) % card_stacks.size()
		await AnimThread.await_anim_okay()

func play_stack(chain: Array[CardData], enemy: EnemyData) -> void:
	var result = CardData.compute_chain(chain, enemy, self)
	for i in range(chain.size()-1,-1,-1):
		var card = chain[i]
		await play_card(card)
	result.apply(chain, enemy, self)
	gain_enemy_action_points(1)
	check_enemies()

	var all_empty = true
	for cs in card_stacks:
		if cs.size() > 0:
			all_empty = false
	if all_empty:
		deal_cards()

func play_card(card: CardData) -> void:
	for i in range(card_stacks.size()):
		var stack = card_stacks[i]
		var idx = stack.find(card)
		if idx >= 0:
			stack.pop_at(idx)
			card_played.emit(card)
			card.flip_card(Enums.CardFace.BACK)
			await deck.append(card)
			return
	assert(false, "Card not found in deck")

func gain_enemy_action_points(points: int) -> void:
	for enemy in enemies:
		var old = enemy.action_points
		enemy.action_points += points
		enemy.action_points_changed.emit(old, enemy.action_points)
		if enemy.action_points >= enemy.action_points_threshold:
			if enemy.is_alive():
				enemy.take_action(self)


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

func spawn_enemies() -> void:
	var level_enemies: Array = [
		["grunt", "grunt", "mage"],
		["crow", "crow", "crow", "slime"],
		["slime", "slime", "slime"],
	]
	var enemy_library = EnemyLibrary.new()
	for _name in level_enemies[level]:
		var enemy = enemy_library.make_enemy_by_name(_name, self)
		enemies.append(enemy)
		enemy_made.emit(enemy)
	level += 1

func check_enemies() -> void:
	var any_alive: bool = false
	for enemy in enemies:
		if enemy.is_alive():
			any_alive = true
	if not any_alive:
		advance_level()

func advance_level():
	level_cleared.emit()
	for cs: Array in card_stacks:
		while len(cs) > 0:
			var card = cs.pop_back()
			card.flip_card(Enums.CardFace.BACK)
			await deck.append(card)

	spawn_enemies()
	deal_cards()
