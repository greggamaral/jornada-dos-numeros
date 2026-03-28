extends Sprite2D

func _ready():
	pass

func _process(delta):
	pass

func _on_area_2d_mouse_entered():
	$"../Phase_3".play("new_animation")
	speak_text($Label.text)

func _on_area_2d_mouse_exited():
	$"../Phase_3".play("RESET")

func _on_area_2d_mouse_shape_entered(shape_idx):
	$"../Phase_3".play("new_animation")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file("res://scenes/levels/fase_animais/intro_animais.tscn")

func speak_text(text: String):
	DisplayServer.tts_stop()
	var voices = DisplayServer.tts_get_voices_for_language("pt_BR")
	var voice_id = voices[Global.selected_voice_id]
	DisplayServer.tts_speak(text, voice_id, AudioController.volume, 1.0, 0.8)
