extends State

@export var chase_speed : float = 5000.0
var target : CharacterBody2D
var animation_player: AnimationPlayer

func initialize():
	animation_player = body.get_node("MainSprite/AnimationPlayer")

func process_state(delta: float):
	body.velocity = (target.position - body.position).normalized() * chase_speed * delta
	body.move_and_slide()
	animation_player.play("move_right")
