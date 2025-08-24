extends Label

var score = 0

var score_format = "Score: %s"

func _on_mob_squashed():
	score += 1
	text = score_format % score
