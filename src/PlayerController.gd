extends CharacterBody3D

@export var move_speed: float = 5.0
@export var jump_force: float = 4.5
@export var mouse_sensitivity: float = 0.002

var _camera: Camera3D
var _pitch: float = 0.0

func _ready() -> void:
	# Wait one frame to ensure WorldGenerator has finished adding the camera
	await get_tree().process_frame
	_camera = find_child("Camera3D", true, false)
	
	if _camera:
		print("SUCCESS: Camera found! Look up/down should work.")
	else:
		print("ERROR: Camera3D not found under Player!")
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# YAW: Rotate body Left/Right
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# PITCH: Rotate camera Up/Down
		if _camera:
			_pitch -= event.relative.y * mouse_sensitivity
			_pitch = clamp(_pitch, deg_to_rad(-89), deg_to_rad(89))
			_camera.rotation.x = _pitch

func _physics_process(delta: float) -> void:
	# 1. Gravity & Jump
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	else:
		velocity.y = 0.0
		if Input.is_key_pressed(KEY_SPACE):
			velocity.y = jump_force

	# 2. WASD Movement (Fixed A/D swap)
	var move_dir := Vector3.ZERO
	var basis = transform.basis

	if Input.is_key_pressed(KEY_W): move_dir -= basis.z
	if Input.is_key_pressed(KEY_S): move_dir += basis.z
	if Input.is_key_pressed(KEY_A): move_dir -= basis.x # Negative X is Left
	if Input.is_key_pressed(KEY_D): move_dir += basis.x # Positive X is Right

	move_dir.y = 0 # Keep movement strictly horizontal
	move_dir = move_dir.normalized()

	velocity.x = move_dir.x * move_speed
	velocity.z = move_dir.z * move_speed

	move_and_slide()