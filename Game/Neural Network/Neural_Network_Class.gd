class_name neuralBrain
extends RefCounted

var hidden_nodes:= 0
var inputs := 0
var outputs := 0

var layers = []

class neuralNode:
	var bias : float
	var value : float

var weights = []
#weights - weights[layer][sending][recieveing]

var network : Array[Array]= [[]]
# network - network[layer][node]

func _init(input : int, output : int, hidden : int):
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
				weights[i][j][n] = randf()

func compute(input_values : Array[float]) -> Array[float]:
	
	for i in range(inputs):
		network[0][i].value = input_values[i]
	
	for n in range(2):
		for i in range(layers[n+1]):
			var sum = network[n+1][i].bias
			for j in range(layers[n]):
				sum += network[n][j].value * weights[n][j][i]
			network[n+1][i].value = tanh(sum)
	
	var output_values = []
	for i in range(outputs):
		output_values.append(network[2][i].value)
	return network[2]
 
