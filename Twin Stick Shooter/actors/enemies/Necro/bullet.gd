extends Area2D


const speed = 100

func _process(delta):
	position += transform.x * speed * delta
	
	
func _on_kill_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Collision with player detected. Destroying bullet.")
		queue_free()
