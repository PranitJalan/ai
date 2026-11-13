class_name neuralBrain
extends Resource

@export var hidden_nodes:= 0
@export var inputs := 0
@export var outputs := 0

@export var mutation_chance := 0.1
@export var mutation_strength := 0.3


@export var layers : Array[int] = []

@export var weights = []
#weights - weights[layer][sending][recieveing]

@export var network : Array[Array]= [[]]
# network - network[layer][node]

func _init(input : int = 2, output : int = 8, hidden : int = 9):
	layers.resize(3)
	hidden_nodes = hidden
	layers[1] = hidden
	inputs = input
	layers[0] = input
	outputs = output
	layers[2] = output
	
	# initialize Network
	network.resize(3)
	for i in range(3):
		network[i] = [] as Array[neuralNode]
		var current_layer
		current_layer = layers[i]
		network[i].resize(current_layer)
		for j in range(current_layer):
			network[i][j] = neuralNode.new()
			network[i][j].bias = 0.1
			network[i][j].value = 0.0
	
	# initilize weights
	weights.resize(2)
	for i in range(2):
		var prev_layer
		var next_layer
		prev_layer = layers[i]
		next_layer = layers[i+1]
		weights[i] = []
		weights[i].resize(prev_layer)
		for j in range(prev_layer):
			weights[i][j] = []
			weights[i][j].resize(next_layer)
			for n in range(next_layer):
				weights[i][j][n] = randf_range(-1.0, 1.0)

func compute(input_values : Array[float]) -> Array[float]:
	
	for i in range(inputs):
		network[0][i].value = input_values[i]
	
	for n in range(2):
		for i in range(layers[n+1]):
			var sum = network[n+1][i].bias
			for j in range(layers[n]):
				sum += network[n][j].value * weights[n][j][i]
			network[n+1][i].value = tanh(sum)
	
	var output_values : Array[float]= []
	for i in range(outputs):
		output_values.append(network[2][i].value)
	return output_values
 
func mutate():
	for i in range(2):
		for j in range(layers[i]):
			for n in range(layers[i+1]):
				if randf() < mutation_chance:
					weights[i][j][n] += randf_range(-mutation_strength, mutation_strength)
					weights[i][j][n] = clampf(weights[i][j][n], -2.0, 2.0)
	
	for i in range(3):
		for j in range(layers[i]):
			if randf() < mutation_chance:
				network[i][j].bias += randf_range(-mutation_strength, mutation_strength)
				network[i][j].bias = clampf(network[i][j].bias, -2.0, 2.0)

func copy() -> neuralBrain:
	var new_brain = neuralBrain.new(inputs, outputs, hidden_nodes)
	
	for i in range(2):
		for j in range(layers[i]):
			for n in range(layers[i+1]):
				new_brain.weights[i][j][n] = weights[i][j][n]
	
	for i in range(3):
		for j in range(layers[i]):
			new_brain.network[i][j].bias = network[i][j].bias
			new_brain.network[i][j].value = network[i][j].value
	
	
	return new_brain
