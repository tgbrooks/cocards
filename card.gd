class_name Card extends Node2D

@export var card_name: String = "mycard"
@export var number: int = 0 
@export var suit: Enums.Suit = Enums.Suit.RED
@export var visible_face: Enums.CardFace = Enums.CardFace.BACK

@export var upgrades: Array = []

signal card_flipped(to_front: bool)
@onready var card_face: Node2D = $CardFace
@onready var button: Button = $Button
@onready var number_label: Label = $CardFace/NumberLabel
@onready var name_label: Label = $CardFace/NameLabel
@onready var description_label: Label = $CardFace/DescriptionLabel
@onready var card_sprite: Sprite2D = $CardFace/CardSprite
@onready var preview: Node2D = $Preview
@onready var card_back_sprite: Sprite2D = $CardBackSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number_label.text = "%s" % number
	name_label.text = card_name
	card_sprite.modulate = Util.suit_to_color(suit)
	var descriptions = []
	for upgrade in upgrades:
		descriptions.append(upgrade.description)
	description_label.text = ' '.join(descriptions)
	button.pressed.connect(_on_pressed)

	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_off_hover)

	# Set-up the on-hover preview
#	preview.position = Vector2(card_sprite.texture.get_width() + 10, -10)
	preview.add_child(card_sprite.duplicate(false))
	preview.add_child(number_label.duplicate(false))
	preview.add_child(description_label.duplicate(false))

func _process(_delta: float) -> void:
	# Keep the card preview visible on screen
	var wsize: Vector2 = get_window().size
	var global_loc = global_position.y
	var size = card_sprite.get_rect().size.y * card_sprite.scale.y * preview.scale.y
	var preview_offset = -20
	preview.position.y = min(preview_offset, wsize.y - size - global_loc)

var card_labels:
	get():
		var labels = []
		for upgrade in upgrades:
			for label in upgrade.labels:
				labels.append(label)
		return labels

func _on_pressed() -> void:
	var parent = get_parent()
	if is_instance_of(parent, CardStack):
		parent.card_pressed(self)

func select() -> void:
	scale = Vector2(1.2, 1.2)
	
func unselect() -> void:
	scale = Vector2(1.0, 1.0)
	
func flip_card(face: Enums.CardFace) -> void:
	if face == visible_face:
		return
	visible_face = face
	card_flipped.emit(face)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.0, 1.), 0.25)
	if face == Enums.CardFace.BACK:
		tween.tween_callback(func (): card_back_sprite.visible = true; card_face.visible=false)
	else:
		tween.tween_callback(func (): card_back_sprite.visible = false; card_face.visible =  true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.25)
	await tween.finished

static func can_chain(cards: Array[Card]) -> bool:
	var curr_number = null
	for card in cards:
		if curr_number == null:
			curr_number = card.number
			continue
		if card.number != curr_number -1:
			return false
		curr_number = card.number
	return true

static func compute_chain(cards: Array[Card], enemy: Enemy, main: Main) -> StackResults:
	var result = StackResults.new()

	for i in range(cards.size()-1,-1,-1):
		var card = cards[i]
		for upgrade in card.upgrades:
			upgrade.first_pass.call(result, enemy, main, cards)

	for i in range(cards.size()-1,-1,-1):
		var card = cards[i]
		for upgrade in card.upgrades:
			upgrade.second_pass.call(result, enemy, main, cards)
	return result

func _on_hover():
	if visible_face == Enums.CardFace.FRONT:
		# Pop up a bigger version
		preview.visible = true

func _off_hover():
	preview.visible = false
