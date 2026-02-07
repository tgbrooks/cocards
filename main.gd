class_name Main extends Node2D

const MAX_PLAYER_OIL = 3
const MAX_PLAYER_HEAT = 5

var state = "order_hand"
var selected_card = null
var played_cards: Array[CardStack] = []
var objectives: Array[Objective] = []
var player_oil: int = 0
var player_heat: int = 0
var player_work: int = 0
@onready var heat_text:Label = $HeatText
@onready var oil_text:Label = $OilText
@onready var work_text:Label = $WorkText

signal gain_oil(num_charges: int)
signal gain_heat(num_coins: int)
signal gain_work(num_work: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("Hand").make_deck(self)
	get_node("Hand").deal_hand()

	gain_heat.connect(func(num): player_heat += num)
	gain_heat.connect(func(_num): update_heat())
	gain_oil.connect(func(num): player_oil += num)
	gain_oil.connect(func(_num): update_oil())
	gain_work.connect(func(num): player_work += num)
	gain_work.connect(func(_num): update_work())
	update_heat()
	update_oil()
	update_work()

	var objective_lib = ObjectiveLibrary.new()
	var objective_names = ['grind', 'mash', 'stir']
	for i in range(objective_names.size()):
		var objective_name = objective_names[i]
		var objective = objective_lib.make_objective_by_name(objective_name, self)
		objective.position = Vector2(i * 200, 200)
		var cs = CardStack.new()
		cs.reference = objective
		played_cards.append(cs)
		add_child(objective)
		add_child(cs)
		objectives.append(objective)
		
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		# FOR DEBUG PURPOSES, RESTART GAME
		get_tree().reload_current_scene()
	
func update_heat():
	heat_text.text = "Heat: %s"% Util.format_heat(player_heat)
	
func update_oil():
	oil_text.text = "Oil: %s" % Util.format_oil(player_oil)
	
func update_work():
	work_text.text = "Work: %s" % Util.format_work(player_work)


func finalize_hand_order() -> void:
	pass
	
func play_card() -> void:
	if not objectives:
		return # nothing to play here
		# TODO: advance to the next stage?

	
	var objective = objectives[0]
	var card = get_node("Hand").hand.pop_front()
	
	if not card:
		print("No more cards")
		return
		# TODO: logic for run out of cards?
	card.queue_free()

	gain_heat.emit(card.heat)
	gain_oil.emit(card.oil)
	gain_work.emit(card.work)
	var satisfied = (player_heat >= objective.heat_cost and player_oil >= objective.oil_cost and player_work >= objective.work_cost)
	if satisfied:
		# TODO: should this not be handled by the 'gain_*' signals?
		gain_heat.emit(-objective.heat_cost)
		gain_oil.emit(-objective.oil_cost)
		gain_work.emit(-objective.oil_cost)
		objective.completed.emit()
		player_work = 0
		if player_oil > MAX_PLAYER_OIL:
			player_oil = MAX_PLAYER_OIL
			
		if player_heat > MAX_PLAYER_HEAT:
			print("!!!TOO MUCH HEAT!!!")
		objectives.pop_front()
		objective.queue_free()
	else:
		objective.ongoing.emit()



func _on_go_button_pressed() -> void:
	if state == "order_hand":
		state = "play_cards"
	else:
		play_card()
		# TODO: end stage logic, run out of cards logic
