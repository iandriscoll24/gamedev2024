extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var text_image: Sprite2D = $text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("jelly_idle")
	text_image.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("body entered")
	if body.name == "CharacterBody2D":  # Replace 'Player' with your player node's name
		text_image.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		text_image.visible = false
