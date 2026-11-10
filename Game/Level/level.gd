extends Node2D

@export var population_size := 200
@export var player : PackedScene
var current_generation = []
var generation = 0
var current_winner


func _ready() -> void:
	Engine.time_scale = 20.0
	for i in range(100):
		generation += 1
		spawn_generations()
		while not current_generation.is_empty():
			await get_tree().physics_frame
		print(generation)
	var error = ResourceSaver.save(current_winner, "res://Weights.tres")

func spawn_generations():
	current_generation.clear()
	
	for i in range(population_size):
		var players = player.instantiate()
		if generation > 1:
			players.brain = current_winner.copy()
		if i > 0:
			players.brain.mutate()
		current_generation.append(players)
		players.manager = self
		add_child(players)
