extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var locked = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		locked = !locked
		
		print("locked: ", locked)
	
	if locked:
		
		return
	
	var speed = (%rightHand.get_float("grip") - %rightHand.get_float("trigger")) * 0.01
	
	
	global_position += %rightHand.global_basis.z * speed
	
	var rotate = Input.get_axis("e","q")
	rotate_y(rotate)
	
	var newScale = Input.get_axis("i","o") * 1.01
	
	if newScale != 0:
		if newScale > 0:
			scale *= newScale
		if newScale < 0:
			scale /= -newScale
	
	
	
	pass
