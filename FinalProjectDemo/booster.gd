# Booster.gd
extends Area2D

@export var boost_strength : float = 500.0 # Strength of the upward boost
@onready var player = null

# Called when a body enters the booster area
func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure it's the player character
		player = body
		apply_boost()

# Apply an upward force to the player
func apply_boost():
	if player:
		player.velocity.y = -boost_strength  # Apply an upward velocity
