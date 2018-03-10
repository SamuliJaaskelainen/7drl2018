extends Node2D

func PlayAudio(audioName):
	var audio = find_node(audioName)
	if audio:
		if not audio.playing:
			audio.play()
	else:
		print("Missing audio %s", audioName)
