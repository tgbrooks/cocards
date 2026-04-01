class_name GameView extends Node

var state: GameState
var card_map: Dictionary[CardData, Card] = Dictionary()
@export var selected_card_stack: CardStack = null
var cs_scene = preload("res://card_stack.tscn")
var stack_results_preview: StackResultPreview = null

var card_stacks: Array[CardStack] = []

func _read():
	for i in range(3):
		var cs = cs_scene.instantiate()
		card_stacks.append(cs)
		cs.position = Vector2(200*i+100, 300)
		self.add_child(cs)

func lookup_card(card_data: CardData) -> Card:
	return card_map.get(card_data)
