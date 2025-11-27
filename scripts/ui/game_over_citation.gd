extends TextureRect
class_name GameOverCitation

@export_multiline var content_template:String
@export var aspect_ratio:float = 1

func set_content(title:String, main_text:String, day_number:int, high_score:int):
	%Title.text = title
	%MainText.text = content_template.format({
		"content": main_text,
		"day": day_number,
		"high_score": high_score,
	})
func intro() -> void:
	$AnimationPlayer.play("intro")
