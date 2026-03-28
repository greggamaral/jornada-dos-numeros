extends Node

var previous_scene
var random_number = randi_range(0,4)

func _random(number):
	while random_number == number:
		random_number = randi_range(0,4)

func speak_text(text: String, rate: float = 0.8) -> void:
	DisplayServer.tts_stop()
	var voices = DisplayServer.tts_get_voices_for_language("pt_BR")
	var voice_id = voices[Global.selected_voice_id]
	DisplayServer.tts_speak(text, voice_id, AudioController.volume, 1.0, rate)

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
