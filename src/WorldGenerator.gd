extends Node3D
class_name WorldGenerator

@export var grid_size: int = 20
@export var tile_size: float = 2.0
@export var collision_thickness: float = 2.0 # Thick floor to catch the player
@export var player_spawn_position: Vector3 = Vector3(0.0, 5.0, 0.0)

func _ready() -> void:
	_setup_environment()
	generate()
	_spawn_player()

func _setup_environment() -> void:
	var sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-45, 45, 0)
	add_child(sun)
	
	var env = WorldEnvironment.new()
	var new_env = Environment.new()
	new_env.background_mode = Environment.BG_SKY
	new_env.sky = Sky.new()
	new_env.sky.sky_material = ProceduralSkyMaterial.new()
	env.environment = new_env
	add_child(env)

func generate() -> void:
	_clear_children()
	var plane := PlaneMesh.new()
	plane.size = Vector2(tile_size * 0.98, tile_size * 0.98)

	for zi in range(grid_size):
		for xi in range(grid_size):
			var tile_root := Node3D.new()
			tile_root.position = Vector3(xi * tile_size, 0.0, zi * tile_size)
			add_child(tile_root)

			# Visual Tile
			var tile_mesh := MeshInstance3D.new()
			tile_mesh.mesh = plane
			tile_mesh.rotation.x = -PI * 0.5
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(randf(), randf(), randf())
			tile_mesh.material_override = mat
			tile_root.add_child(tile_mesh)

			# Coordinates Label
			var label = Label3D.new()
			label.text = "%s%d" % [String.chr(65 + (xi % 26)), zi + 1]
			label.font_size = 120
			label.position = Vector3(0, 0.1, 0)
			label.rotation.x = -PI * 0.5
			tile_root.add_child(label)

			# SOLID FLOOR COLLISION
			var body := StaticBody3D.new()
			# Offset the body so the top surface is at Y=0
			body.position = Vector3(0, -collision_thickness * 0.5, 0)
			tile_root.add_child(body)

			var shape := CollisionShape3D.new()
			var box := BoxShape3D.new()
			box.size = Vector3(tile_size, collision_thickness, tile_size)
			shape.shape = box
			body.add_child(shape)

func _clear_children() -> void:
	for child in get_children():
		if not child is DirectionalLight3D and not child is WorldEnvironment:
			child.queue_free()

func _spawn_player() -> void:
	var player := CharacterBody3D.new()
	player.name = "Player"
	player.position = player_spawn_position
	
	var script = load("res://src/PlayerController.gd")
	if script: player.set_script(script)

	var col := CollisionShape3D.new()
	col.shape = CapsuleShape3D.new()
	player.add_child(col)

	var cam := Camera3D.new()
	cam.name = "Camera3D"
	cam.position = Vector3(0, 1.6, 0)
	cam.make_current()
	player.add_child(cam)
	add_child(player)