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
func set_buttons(dict:Dictionary[String,Callable]):
	for button in %Buttons.get_children():
		button.queue_free()
	for btn_name in dict.keys():
		var btn = Button.new()
		btn.theme_type_variation = "CitationButtons"
		btn.flat = true
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.text = btn_name
		btn.pressed.connect(dict[btn_name]) #Connect signal
		%Buttons.add_child(btn)
func intro() -> void:
	hide()
	$AnimationPlayer.play("intro")
	call_deferred("show")

func outro() -> void:
	$AnimationPlayer.play("outro")
	await $AnimationPlayer.animation_finished
	hide()
