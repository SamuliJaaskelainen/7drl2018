extends Node2D

func PlayAudio(audioName):
	var audio = find_node(audioName)
	if not audio.playing:
		audio.play()
