extends Area2D

func _ready():
	pass

func _process(delta):
	pass

func _on_mouse_entered():
	$"../../AnimationPlayer".play("new_animation")

func _on_mouse_exited():
	$"../../AnimationPlayer".play("RESET")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://node_2d.tscn")
