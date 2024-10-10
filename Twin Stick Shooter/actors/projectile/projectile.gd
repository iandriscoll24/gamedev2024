extends Area2D

const Enemy = preload("res://actors/enemies/Slime/basic_enemy.gd")

var velocity: Vector2 = Vector2(0, 0)

# Fire the projectile toward the mouse cursor from a given starting position
func fire(start_position: Vector2, direction: Vector2, speed: float):
	# Set the projectile's position to the starting point (e.g., the bow's position)
	position = start_position

	# Set the velocity based on the direction and speed
	velocity = direction * speed

	# Make the projectile face toward the direction it's fired
	look_at(position + direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta

func _on_time_to_live_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit(1)
	queue_free()
