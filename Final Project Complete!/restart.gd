extends CanvasLayer

func _on_button_pressed() -> void:
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
