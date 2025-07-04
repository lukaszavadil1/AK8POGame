extends Node

var audio_player = AudioStreamPlayer.new()
var current_music: AudioStream

func _ready():
	add_child(audio_player)
	audio_player.bus = "Music"
	audio_player.finished.connect(_on_finished)

func play_music(music: AudioStream):
	if current_music == music and audio_player.playing:
		return
		
	current_music = music
	audio_player.stream = music
	audio_player.play()

func _on_finished():
	audio_player.play()
