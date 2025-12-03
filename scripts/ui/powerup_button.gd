extends Button
class_name PowerupButton

@export var lock_enabled_state:bool
var amount:int:
	set(new):
		amount = new
		%Amount.text = ""+str(amount)
		if amount <= 0:
			hide()
		else:
			show()


func _value_changed(num: int) -> void:
	amount = num

func in_effect() -> void:
	if lock_enabled_state:
		%EnabledShader.show()

func out_of_effect() -> void:
	if lock_enabled_state:
		%EnabledShader.hide()
