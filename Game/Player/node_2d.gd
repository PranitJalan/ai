extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var gravity := 900
@export var friction := 300
@export var acceleration := 300
@export var max_speed := 1000
@export var jump_strength := 400

var direction := 0
var jump := false
var brain := neuralBrain.new(6, 2, 16)
var width
var fitness = 0.0
var manager

func _ready() -> void:
	width = get_viewport_rect().size

func go() -> void:
	manager.current_generation.erase(self)
	manager.current_winner = brain.copy()
	queue_free()

func _physics_process(delta: float) -> void:
	get_input()
	do_movement(delta)
	move_and_slide()
	fitness += delta

func get_input():
	var input : Array[float] = []
	input.append(position.x/width.x)
	input.append(position.y/width.y)
	input.append(velocity.x/width.x)
	input.append(velocity.y/width.y)
	var level = get_tree().get_first_node_in_group("level")
	var gap = level.get_next_gap(position.x)
	input.append(gap.x/width.x)
	input.append(gap.y/width.x)
	var outputs = brain.compute(input)
	if outputs[0] < -0.25:
		direction = -1
	elif outputs[0] < 0.25:
		direction = 0
	else:
		direction = 1
	if outputs[1] > 0:
		jump = true

func do_movement(delta):
	if direction:
		velocity.x = move_toward(velocity.x, max_speed*direction, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction*delta)
	if is_on_floor():
		if jump:
			velocity.y -= jump_strength
	else:
		velocity.y += gravity*delta
	jump = false
