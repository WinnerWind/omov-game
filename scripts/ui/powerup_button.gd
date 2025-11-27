extends Button
class_name PowerupButton

var amount:int:
	set(new):
		amount = new
		%Amount.text = "x"+str(amount)
		if amount <= 0:
			hide()
		else:
			show()


func _value_changed(num: int) -> void:
	amount = num
