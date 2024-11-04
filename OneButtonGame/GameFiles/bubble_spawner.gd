extends Node2D

@export var bubble_scene : PackedScene = preload("res://bubble.tscn")
@export var spawn_position := Vector2(600, 500)  # Adjust as needed
@onready var timer = $bubblespawntimer
var spawn_time := randi() % 10 + 1

func _ready():
	timer.wait_time = spawn_time
	timer.start()

# Spawns a bubble at the specified position
func spawn_bubble():
	var bubble = bubble_scene.instantiate()
	add_child(bubble)
	var min_x = 50
	var max_x = 1800
	var min_y = 500
	var max_y = 1000
	bubble.global_position = Vector2(min_x + randi() % (max_x - min_x), min_y + randi() % (max_y - min_y))
	bubble.set_bubble_spawner(self)


func _on_bubblespawntimer_timeout() -> void:
	spawn_bubble()

func increase_timer():
	spawn_time = clamp(spawn_time + 1.0, 2.0, 15.0)  # Max time of 15 seconds, min of 2 seconds
	timer.wait_time = spawn_time  # Update the timer's wait time
	print("SpawnTime: ", spawn_time)
