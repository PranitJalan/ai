extends Node2D
@onready var label: Label = $World/Label

@export var population_size := 10
@export var player : PackedScene
@export var real_player : PackedScene
@export var world : PackedScene
var current_generation = []
var generation = 0
var current_winner : neuralBrain
var who
func _new_brain() -> void:
	var new = neuralBrain.new()
	var error = ResourceSaver.save(new, "res://Weights.tres")
	if error == OK:
		print("Resource saved successfully!")
	else:
		print("Failed to save resource. Error code: ", error)


func _play() -> void:
	var ah = world.instantiate()
	add_child(ah)
	var players = player.instantiate()
	current_winner = ResourceLoader.load("res://Weights.tres") as neuralBrain
	players.brain = current_winner.copy()
	players.manager = self
	current_generation.append(players)
	add_child(players)
	players = real_player.instantiate()
	players.manager = self
	current_generation.append(players)
	add_child(players)
	while not current_generation.is_empty():
			await get_tree().physics_frame
	label.position = Vector2(565, 135)
	label.add_theme_font_size_override("font_size", 40)
	if who == "ai":
		label.text = "AI WINS"
	else:
		label.text = 'YOU WIN'

func _ready() -> void:
	_play()


func _train() -> void:
	var eheh = ResourceLoader.load("res://Weights.tres") as neuralBrain
	current_winner = eheh.copy()
	Engine.time_scale = 1.0
	Engine.physics_ticks_per_second = 60*20
	Engine.max_physics_steps_per_frame = 20
	for i in range(20):
		var ah = world.instantiate()
		ah.visible = true
		add_child(ah)
		generation += 1
		spawn_generations()
		while not current_generation.is_empty():
			await get_tree().physics_frame
		print(generation)
		remove_child(ah)
		ah.queue_free()
	var error = ResourceSaver.save(current_winner, "res://Weights.tres")
	
	if error == OK:
		print("Resource saved successfully!")
	else:
		print("Failed to save resource. Error code: ", error)
		
func spawn_generations():
	current_generation.clear()
	
	for i in range(population_size):
		var players = player.instantiate()
		players.brain = current_winner.copy()
		if i < population_size-1:
			players.brain.mutate()
		current_generation.append(players)
		players.manager = self
		players.visible = true
		add_child(players)
