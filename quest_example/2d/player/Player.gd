extends QuestPlayer2D

const FLOOR_NORMAL: = Vector2.UP
export var speed: = Vector2(400.0, 500.0)
export var gravity: = 1000.0
var _direction = true
var _velocity: = Vector2.ZERO
export(String) var attack = "attack"

onready var _animationPlayer = $AnimationPlayer as AnimationPlayer

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	var is_jump_interrupted: = Input.is_action_just_released("move_up") and _velocity.y < 0.0
	var direction: = get_direction()
	if direction.x != 0:
		_direction = direction.x > 0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("move_up") if is_on_floor() and Input.is_action_just_pressed("move_up") else 0.0)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed_param: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed_param.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed_param.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity

func _input(event: InputEvent):
	if event.is_action_released(attack):
		if _direction:
			_animationPlayer.play("attack_right")
		else:
			_animationPlayer.play("attack_left")

# Methods for requerements
func is_valid_player() -> bool:
	return true

func player_lvl() -> int:
	return 5 

func player_class() -> String:
	return "PALADIN" 
