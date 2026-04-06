class_name EnemyArea extends Node2D

var enemy_scene = preload("res://enemy.tscn")
var data_to_enemy: Dictionary[EnemyData, Enemy] = {}

signal on_enemy_pressed(enemy: Enemy)

var state: GameState:
	set(value):
		state = value
		_on_state_set()
@onready var main = get_parent()

func _process(_delta):
	_position_enemies()

func _on_state_set():
	state.enemy_made.connect(_make_enemy)

func _make_enemy(data: EnemyData):
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.data = data
	data_to_enemy[data] = enemy
	add_child(enemy)
	enemy.button.pressed.connect(on_enemy_pressed.emit.bind(enemy))

var enemies: Array[Enemy]:
	get:
		var es: Array[Enemy] = []
		for child in get_children():
			if is_instance_of(child, Enemy):
				es.append(child)
		return es

func _position_enemies() -> void:
	var top: int = 0
	for i in enemies.size():
		var enemy = enemies[i]
		enemy.position = Vector2(0, top)
		top += enemy.button.size.y + 10

func lookup_enemy(data: EnemyData) -> Enemy:
	return data_to_enemy[data]
