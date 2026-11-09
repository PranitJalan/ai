extends Node2D

@export var block_size := Vector2(0, 0)
@export var scroll_speed := 0

@export var block : PackedScene 


var global_spawn := 0.0

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
		for i in range(size_gap):
			global_spawn += block_size.x
 
func remove_offscreen():
	for i in get_children():
		if i.global_position.x < -block_size.x*2:
			i.queue_free()

func spawn_block():
	var blocky = block.instantiate()
	blocky.position = Vector2(global_spawn, (get_viewport_rect().size.y - block_size.y/2))
	add_child(blocky)
