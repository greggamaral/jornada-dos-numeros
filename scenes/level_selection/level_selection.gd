extends Node2D

@onready var focusable_nodes: Array[Node] = [$Label, $"1/Label", $"2/Label",$"3/Label" ]

var current_index: int = 0

func _ready():
	if focusable_nodes.size() > 0:
		_set_focus_to_current()

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			_move_focus_forward()
		elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			load_level(current_index)

func _move_focus_forward():
	current_index = (current_index + 1) % focusable_nodes.size()
	_set_focus_to_current()

func _set_focus_to_current():
	if is_instance_valid(focusable_nodes[current_index]):
		focusable_nodes[current_index].grab_focus()
	if current_index == 0:
		AutoloadScene.speak_text("Utilize Tab para escolher uma fase e depois pressione Enter", 1.0)
	else:
		AutoloadScene.speak_text(focusable_nodes[current_index].text, 1.0)
	if current_index == 1:
		$Phase_1.play("new_animation")
		$Phase_2.play("RESET")
		$Phase_3.play("RESET")
	elif current_index == 2:
		$Phase_1.play("RESET")
		$Phase_2.play("new_animation")
		$Phase_3.play("RESET")
	elif current_index == 3:
		$Phase_1.play("RESET")
		$Phase_2.play("RESET")
		$Phase_3.play("new_animation")
	else:
		$Phase_1.play("RESET")
		$Phase_2.play("RESET")
		$Phase_3.play("RESET")

func load_level(current_index: int):
	if current_index == 1:
		get_tree().change_scene_to_file("res://scenes/levels/fase_balanca/intro_to_balanca.tscn")
	elif current_index == 2:
		get_tree().change_scene_to_file("res://scenes/levels/fase_bau/Trunk_Puzzle_Introduction.tscn")
	elif current_index == 3:
		DisplayServer.tts_stop()
		get_tree().change_scene_to_file("res://scenes/levels/fase_animais/intro_animais.tscn")
	else:
		AutoloadScene.speak_text("Utilize Tab para escolher uma fase e depois pressione Enter", 1.0)
