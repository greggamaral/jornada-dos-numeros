extends Sprite2D

func _ready():
	pass

func _process(delta):
	pass

func _on_area_2d_mouse_entered():
	$"../Phase_2".play("new_animation")
	AutoloadScene.speak_text($Label.text)

func _on_area_2d_mouse_exited():
	$"../Phase_2".play("RESET")

func _on_area_2d_mouse_shape_entered(shape_idx):
	$"../Phase_2".play("new_animation")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scenes/levels/fase_bau/Trunk_Puzzle_Introduction.tscn")
