extends Node2D

@onready var scene_transition_anim = $"../SceneTransitionAnimation/AnimationPlayer"
@onready var initial_text = $AnimationPlayer

func _ready():
	scene_transition_anim.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	scene_transition_anim.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	initial_text.play("fade_in_introduction")
	await get_tree().create_timer(10).timeout
	await get_tree().create_timer(8).timeout
	$"../AudioStreamPlayer2".play()
	await get_tree().create_timer(8).timeout
	scene_transition_anim.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/intro/story.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/intro/story.tscn")
