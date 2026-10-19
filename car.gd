extends CharacterBody3D
@export var acceleration: float = 12.0
@export var reverse_speed: float = 6.0
@export var max_speed: float = 22.0
@export var steering_speed: float = 1.8
@export var friction: float = 8.0
var current_speed: float = 0.0
var gravity: float = 20
func _physics_process(delta: float) -> void:
	var throttle = Input.get_axis("reverse", "accelerate")
	var steering = Input.get_axis("steerright", "steerleft")
	if throttle > 0.0:
		current_speed = move_toward(
			current_speed,
			max_speed,
			acceleration * delta
	)
	elif throttle < 0.0:
		current_speed = move_toward(
			current_speed,
			-reverse_speed,
			acceleration * delta
		)
	else:
		current_speed = move_toward(
			current_speed,
			0.0,
			friction * delta
		)
	if Input.is_action_pressed("handbrake"):
		current_speed = move_toward(
			current_speed,
			0.0,
			friction * 3.0 * delta
		)
	var turn_amount = steering * steering_speed
	turn_amount *= clamp(abs(current_speed) / 5, 0, 1)
	if current_speed <0:
		turn_amount *= -1.0
	rotate_y(turn_amount * delta)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	velocity.x = (-global_basis.z * current_speed).x
	velocity.z = (-global_basis.z * current_speed).z
	move_and_slide()
