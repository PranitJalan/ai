extends CharacterBody2D


@export var gravity := 900
@export var friction := 300
@export var acceleration := 300
@export var max_speed := 1000
@export var jump_strength := 400

var direction := 0
var jump := false

func _physics_process(delta: float) -> void:
	get_input()
	do_movement(delta)
	move_and_slide()


func get_input():
	direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
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
