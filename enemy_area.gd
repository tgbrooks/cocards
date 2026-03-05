class_name EnemyArea extends Node2D

signal enemy_action_taken(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var enemies: Array[Enemy]:
	get:
		var enemies: Array[Enemy] = []
		for child in get_children():
			if is_instance_of(child, Enemy):
				enemies.append(child)
		return enemies

func spawn_enemies() -> void:
	var main = get_parent()
	var enemy_library = EnemyLibrary.new()
	for _name in ["grunt", "grunt", "mage"]:
		var enemy = enemy_library.make_enemy_by_name(_name, main)
		add_child(enemy)
		enemy.add_to_group("enemies")
		enemy.pressed.connect(main.on_enemy_pressed.bind(enemy))
		enemy.on_hover.connect(main.preview_stack_results.bind(enemy))
		enemy.off_hover.connect(main.clear_stack_results_preview)
	_position_enemies()

func _position_enemies() -> void:
	var top: int = 0
	var enemies: Array[Node] = get_children(false)
	for i in enemies.size():
		var enemy = enemies[i]
		enemy.position = Vector2(0, top)
		top += enemy.size.y + 10

func gain_action_points(points: int) -> void:
	for enemy in enemies:
		var old = enemy.action_points
		enemy.action_points += points
		enemy.action_points_changed.emit(old, enemy.action_points)
		if enemy.action_points >= enemy.action_points_threshold:
			old = enemy.action_points
			enemy.action_points = 0
			await enemy.take_action(get_parent())
			enemy.action_points_changed.emit(enemy.action_points, 0)
