class_name EnemyArea extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemies() -> void:
	var main = get_parent()
	var enemy_library = EnemyLibrary.new()
	for _name in ["grunt", "grunt", "mage"]:
		var enemy = enemy_library.make_enemy_by_name(_name, main)
		add_child(enemy)
		enemy.add_to_group("enemies")
		enemy.pressed.connect(main.on_enemy_pressed.bind(enemy))
		main.enemy_action_taken.connect(enemy.take_action.bind(main))
	_position_enemies()

func _position_enemies() -> void:
	var top: int = 0
	var enemies: Array[Node] = get_children(false)
	for i in enemies.size():
		var enemy = enemies[i]
		enemy.position = Vector2(0, top)
		top += enemy.size.y + 10
