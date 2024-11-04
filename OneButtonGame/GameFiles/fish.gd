extends Area2D

@export var speed: float = randf_range(200.0, 500.0)
@export var vertical_amplitude: float = randf_range(20.0, 100.0)  # Up and down movement
@export var vertical_speed: float = 3.0  # Speed of up and down movement
@onready var animation_player = $FishSprite/AnimationPlayer
@onready var fish_sprite = $FishSprite  # Reference to the sprite node
var direction: Vector2 = Vector2(-1, 0)  # Start moving left
var velocity: Vector2 = Vector2.ZERO
var elapsed_time: float = 0.0  # Track time for vertical movement

func _ready() -> void:
	# Set initial velocity based on speed
	velocity = Vector2(speed * direction.x, 0)

	# Flip sprite if moving to the right
	fish_sprite.flip_h = direction.x <= 0  # Flip for left movement

	play_animation("fish_move")

func _process(delta: float) -> void:
	# Track elapsed time for sine wave calculation
	elapsed_time += delta

	# Update vertical position for floating effect
	position.y += vertical_amplitude * sin(vertical_speed * elapsed_time) * delta

	# Move the fish horizontally based on its velocity
	position += velocity * delta

	# If the fish goes off the screen, queue it for deletion
	if position.x < -1200 or position.x > get_viewport().size.x + 100:
		queue_free()

func play_animation(anim_name: String):
	print("Playing animation: ", anim_name)  # Debug print
	animation_player.stop()
	animation_player.play(anim_name)

func _on_body_entered(body):
	if body.name == "frogRigid":  # Change this to match your frog node's name
		body.game_over()  # Call game_over() on the frog to trigger the game over
