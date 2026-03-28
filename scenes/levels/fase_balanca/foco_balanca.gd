extends Node2D

@onready var focusable_nodes: Array[Node] = [$balanca/conta, $balanca/SpinBox, $balanca/Label]

var current_index: int = 0
var conta

func _ready():
	AutoloadScene.previous_scene = "res://scenes/levels/fase_balanca/balanca.tscn"
	if focusable_nodes.size() > 0:
		_set_focus_to_current()

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			_move_focus_forward()
		elif event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			submit_answer()
		elif event.keycode == KEY_ESCAPE:
			DisplayServer.tts_stop()
			AudioController._play_select()
			AudioController._pause_backmusic(true)
			get_tree().change_scene_to_file("res://scenes/menu/menu_pausa.tscn")

func _move_focus_forward():
	current_index = (current_index + 1) % focusable_nodes.size()
	_set_focus_to_current()

func _set_focus_to_current():
	if is_instance_valid(focusable_nodes[current_index]):
		focusable_nodes[current_index].grab_focus()
	if current_index != 1:
		if current_index == 0:
			conta = focusable_nodes[current_index].text.replace("*", "vezes")
			conta = conta.replace("/", "dividido por")
			conta = conta.replace("-", "menos")
			conta = conta.replace("+", "mais")
			AutoloadScene.speak_text(conta)
		else:
			AutoloadScene.speak_text(focusable_nodes[current_index].text)
	else:
		AutoloadScene.speak_text("insira sua resposta")

func submit_answer():
	pass
