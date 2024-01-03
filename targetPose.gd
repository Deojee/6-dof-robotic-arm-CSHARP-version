@tool

extends Node3D

var tip 

# Called when the node enters the scene tree for the first time.
func _ready():
	tip = $shoulderSegment/targetPos
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$debugCube2.global_position = tip.global_position + tip.global_basis.z * 0.1
	
	var speed = 0.01
	
	if Input.is_action_pressed("ui_down"):
		position.z += speed;
	if Input.is_action_pressed("ui_up"):
		position.z -= speed;
	if Input.is_action_pressed("ui_right"):
		position.x += speed;
	if Input.is_action_pressed("ui_left"):
		position.x -= speed;
	
	
	pass
