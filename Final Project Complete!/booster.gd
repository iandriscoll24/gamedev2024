# Booster.gd
extends Area2D

@export var boost_strength : float = 1000.0 # Strength of the upward boost
@onready var player = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer  # Reference to the AnimationPlayer node

func _ready() -> void:
	animation_player.play("bubbles")
# Called when a body enters the booster area
func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure it's the player character
		player = body
		apply_boost()

# Apply an upward force to the player
func apply_boost():
	if player:
		player.velocity.y = -boost_strength  # Apply an upward velocity
		player.velocity.x = 0
