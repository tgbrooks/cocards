class_name FullDeckDisplay extends Node2D

var deck: Array[Card] = []

func _ready() -> void:
	var i = 0
	var num_cols = 4
	var col_width = 150
	var vert_spacing = 170
	for card in deck:
		var col = i % num_cols
		@warning_ignore("integer_division")
		var row = i / num_cols
		add_child(card)
		card.position = Vector2(row*vert_spacing, col*col_width)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
