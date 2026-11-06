class_name neuralBrain
extends RefCounted

var hidden_nodes:= 0
var inputs := 0
var outputs := 0
var biases = []
var weights = []


func _init(input : int, output : int, hidden : int):
	hidden_nodes = hidden
	inputs = input
	outputs = output
	
	# Initialize Biases
	biases.resize(3)
	for i in range(3):
		biases[i] = []
		var current_layer
		if i == 0:
			current_layer = inputs
		elif i == 1:
			current_layer = hidden_nodes
		else:
			current_layer = outputs
		biases[i].resize(current_layer)
		for j in range(current_layer):
			biases[i][j] = 0.0
	
	# Initilize weights
	weights.resize(2)
	for i in range(2):
		var prev_layer
		var next_layer
		if i == 0:
			prev_layer = inputs
			next_layer = hidden_nodes
		elif i == 1:
			prev_layer = hidden_nodes
			next_layer = outputs
		weights[i] = []
		weights[i].resize(prev_layer)
		for j in range(prev_layer):
			weights[i][j] = []
			weights[i][j].resize(next_layer)
			for n in range(next_layer):
				weights[i][j][n] = randf()

 
