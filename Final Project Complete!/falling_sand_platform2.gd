extends RigidBody2D
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

const initial_position = Vector2(996, -744)

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("shake")


func _on_animation_player_animation_finished(anim_name: String) -> void:
	anim_name == "shake"
	set_deferred("freeze", false)
	timer.start()
	


func _on_timer_timeout() -> void:
	set_deferred("freeze", true)
	position = initial_position
	timer.start()
