extends Node2D

@export var block_size := Vector2(0, 0)
@export var scroll_speed := 0

@export var block : PackedScene 


var global_spawn := 0.0
var gaps : Array[Vector2]

func _ready() -> void:
	spawn_level()



func _process(delta: float) -> void:
	position.x -= scroll_speed*delta
	spawn_level()
	remove_offscreen()

func spawn_level():
	var where_to_spawn = to_local(Vector2(get_viewport_rect().size.x + block_size.x*2, 0)).x
	while global_spawn < where_to_spawn:
		var size_cluster = randi_range(1 , 3)
		for i in range(size_cluster):
			global_spawn += block_size.x
			spawn_block()
		var size_gap = randi_range(1 , 3)
		var start = global_spawn + block_size.x/2.0
		var len = size_gap * block_size.x
		gaps.append(Vector2(start, len))
		for i in range(size_gap):
			global_spawn += block_size.x
 
func remove_offscreen():
	for i in get_children():
		if i.global_position.x < -block_size.x*2:
			i.queue_free()
	while not gaps.is_empty():
		var i = gaps[0]
		if to_global(Vector2(i.x, 0)).x < 0:
			gaps.pop_front()
		else:
			break

func spawn_block():
	var blocky = block.instantiate()
	blocky.position = Vector2(global_spawn, (get_viewport_rect().size.y - block_size.y/2))
	add_child(blocky)

func get_next_gap(player_x: float) -> Vector2:
	for i in gaps:
		if player_x < to_global(Vector2(i.x, 0)).x:
			return Vector2(to_global(Vector2(i.x, 0)).x, i.y)
	return Vector2(0, 0)
