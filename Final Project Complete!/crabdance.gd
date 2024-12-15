extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text_image: Sprite2D = $text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Crab dance")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
