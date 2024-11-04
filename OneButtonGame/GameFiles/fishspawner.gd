extends Node2D

@export var fish_scene: PackedScene  # Drag the Fish.tscn here in the editor
@export var min_spawn_time: float = 1.0  # Minimum time between spawns
@export var max_spawn_time: float = 1.5  # Maximum time between spawns

var spawn_timer: float = 0.0

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_fish()
		spawn_timer = randf_range(min_spawn_time, max_spawn_time)  # Random spawn time

func spawn_fish():
	var fish_instance = preload("res://fish.tscn").instantiate()
	
	# Randomly choose whether to spawn from the left or right
	if randi() % 2 == 0:  # 50% chance to spawn from the left
		fish_instance.position = Vector2(-100, randf_range(50, 1050))  # Start off-screen left
		fish_instance.direction = Vector2(1, 0)  # Moving right
	else:  # Spawn from the right
		fish_instance.position = Vector2(get_viewport().size.x + 100, randf_range(50, 1050))  # Start off-screen
		fish_instance.direction = Vector2(-1, 0)  # Moving left
		
	var random_scale = randf_range(1.0, 2.0)
	fish_instance.scale = Vector2(random_scale, random_scale)  # Apply the scale to both x and y


	get_parent().add_child(fish_instance)
