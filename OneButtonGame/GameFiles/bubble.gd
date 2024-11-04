# Bubble.gd

extends Area2D  # Ensure this is the correct type, like Node2D or Sprite2D

@export var bubble_speed := -100.0
@onready var bubblepop = $bubblepop
var bubble_spawner: Node
@onready var animation_player = $BubbleSprite/AnimationPlayer

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	bubble_spawner = get_parent().get_node("/root/OneButtonDiveScene/BubbleSpawner")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	play_animation("bubble_move")


func _process(delta):
	
	# Move the bubble downwards by adjusting the position
	position.y += bubble_speed * delta

	# If the bubble goes off the bottom of the screen, free it
	if position.y > get_viewport_rect().size.y:
		queue_free()

func _on_body_entered(body):
	if body.name == "frogRigid":
		bubblepop.play()
		play_animation("bubble_pop")
		body.on_bubble_collected()  # Call a function in the diver script to increase air
		
		if bubble_spawner:  # Check if the reference is valid
			bubble_spawner.increase_timer()

func set_bubble_spawner(spawner: Node):
	bubble_spawner = spawner

func play_animation(anim_name: String):
		animation_player.stop()
		animation_player.play(anim_name)
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "bubble_pop":
		queue_free()  # Remove the bubble after it's collected
