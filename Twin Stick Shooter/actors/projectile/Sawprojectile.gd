extends Area2D

const Enemy = preload("res://actors/enemies/Slime/basic_enemy.gd")
# Export this variable so it can be set from the instantiation script
@export var initial_position: Vector2 = Vector2.ZERO
@onready var anim = $AnimatedSprite2D

func _ready():
	# Set the initial position from the provided value
	anim.play("SawSpin")
	global_position = initial_position

func _process(delta: float) -> void:
	# Update the laser's position to follow the mouse cursor
	global_position = get_global_mouse_position()

	# Optionally, rotate the laser to face the cursor direction
	look_at(get_global_mouse_position())

func _on_time_to_live_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Damage the enemy when hit
	if body is Enemy:
		body.hit(3)
	queue_free()
