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


func _position_enemies() -> void:
	var top: int = 0
	var enemies: Array[Node] = get_children(false)
	for i in enemies.size():
		var enemy = enemies[i]
		enemy.position = Vector2(0, top)
		top += enemy.size.y + 10
