@tool

extends Node3D

var serial

@export var targetPos : Node3D

@export_category("shoulder")
@export_range(0,360,2) var robotYaw : float = 0
@export_range(0,360,2) var shoulderAngle : float = 0

@export_category("elbow")
@export_range(0,360,2) var elbowAngle : float = 0
@export_range(0,360,2) var elbowTwistAngle : float = 0

@export_category("wrist")
@export_range(0,360,2) var wristAngle : float = 0
@export_range(0,360,2) var wristTwistAngle : float = 0

@export var shouldIk = false

var lengthsInMM: Array[int] = [200,254,55,150,145.0/2.0,145.0/2.0]

var bottomPivot
var baseShoulder
var shoulder
var elbow
var elbowTwist
var wristBend
var wristTwist

var nodeReferences = []

var framesSinceMove = 0

var IKCalc : sixDOFArm= sixDOFArm.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assign references to nodes
	bottomPivot = $baseBlock/bottomPivot
	
	shoulder = $baseBlock/bottomPivot/baseShoulder/shoulder
	elbow = $baseBlock/bottomPivot/baseShoulder/shoulder/elbow
	elbowTwist = $baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist
	wristBend = $"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend"
	wristTwist = $"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend/wrist twist"
	
	serial = $serialCom
	
	nodeReferences.append(bottomPivot)
	nodeReferences.append(shoulder)
	nodeReferences.append(elbow)
	nodeReferences.append(elbowTwist)
	nodeReferences.append(wristBend)
	nodeReferences.append(wristTwist)
	
	
	

var frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	 # Access nodes using variables
	
	if Engine.is_editor_hint():
		return
	
	frame += 1
	
	if Input.is_action_pressed("ui_select") :
		var message = "<a"
		
		for number in IKCalc.targetRotations:
			message += ", " + str(int(number * 57.2958))
		message += ">"
		
		print("Wrote: ", message)
		
		print(serial.Write(message))
	
	$baseBlock/bottomPivot/baseShoulder/shoulder.position.y = lengthsInMM[0]/1000.0
	
	$baseBlock/bottomPivot/baseShoulder/shoulder/shoulderSegment.mesh.size.y = lengthsInMM[1]/1000.0
	$baseBlock/bottomPivot/baseShoulder/shoulder/shoulderSegment.position.y = lengthsInMM[1]/1000.0 /2.0
	$baseBlock/bottomPivot/baseShoulder/shoulder/elbow.position.y = lengthsInMM[1]/1000.0
	
	$baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowSegmentMesh.mesh.size.y = lengthsInMM[2]/1000.0
	$baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowSegmentMesh.position.y = lengthsInMM[2]/1000.0 / 2.0
	$baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist.position.y = lengthsInMM[2]/1000.0
	
	$baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/elbowTwistSegmentMesh.mesh.size.y = lengthsInMM[3]/1000.0
	$baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/elbowTwistSegmentMesh.position.y = lengthsInMM[3]/1000.0 / 2.0
	$"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend".position.y = lengthsInMM[3]/1000.0
	
	$"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend/wristBendMesh".position.y = lengthsInMM[4]/1000.0 / 2.0
	$"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend/wristBendMesh".mesh.size.y = lengthsInMM[4]/1000.0 
	$"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend/wrist twist".position.y = lengthsInMM[4]/1000.0 

	$"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend/wrist twist/endSegmentMesh".position.y = lengthsInMM[5]/1000.0 / 2.0
	$"baseBlock/bottomPivot/baseShoulder/shoulder/elbow/elbowTwist/wrist bend/wrist twist/endSegmentMesh".mesh.size.y = lengthsInMM[5]/1000.0
	
	
	
	
	if shouldIk:
		
		var targetPosition = targetPos.tip.global_position - bottomPivot.global_position
		var tipBasis : Basis = targetPos.tip.global_transform.basis
		
		#both of these methods are valid.
		#IKCalc.calculateAngles(targetPosition,tipBasis.z ,tipBasis.y)
		IKCalc.calculateAnglesFromEulerRotation(targetPosition,targetPos.tip.global_rotation)
		
		setAnglesRadians(IKCalc.targetRotations)
		
		$ui/Marker2D/segment1.rotation = IKCalc.targetRotations[1] - PI/2
		$ui/Marker2D/segment1/segment2.rotation = IKCalc.targetRotations[2] #- PI/2
		
		#print(IKCalc.targetRotations)
		
		pass
	else:
		nodeReferences[0].rotation_degrees.y = robotYaw
		nodeReferences[1].rotation_degrees.x = shoulderAngle
		nodeReferences[2].rotation_degrees.x = elbowAngle
		nodeReferences[3].rotation_degrees.y = elbowTwistAngle
		nodeReferences[4].rotation_degrees.x = wristAngle
		nodeReferences[5].rotation_degrees.y = wristTwistAngle
	
	


func setAnglesRadians(angles):
	
	nodeReferences[0].rotation.y = angles[0]
	nodeReferences[1].rotation.x = angles[1]
	nodeReferences[2].rotation.x = angles[2]
	nodeReferences[3].rotation.y = angles[3]
	nodeReferences[4].rotation.x = angles[4]
	nodeReferences[5].rotation.y = angles[5]
	




func angleDifferenceRadians(angleA: float, angleB: float) -> float:
	var diff = fmod((angleA - angleB + PI), PI * 2) - PI
	return abs(diff)


var lastMessage = ""
func _on_arduino_update_timer_timeout():
	
	var message = "<a"
	
	for number in IKCalc.targetRotations:
		message += ", " + str(int(number * 57.2958))
	message += ">"
	
	
	serial = $serialCom
	
	#message = "0|" + str(int(IKCalc.targetRotations[1] * 57.2958)) + "|~"
	
	#if lastMessage == message:
	#	return
	
	lastMessage = message
	print("Wrote: ", message)
	
	#message = "1";
	
	#DisplayServer.clipboard_set(message)
	
	serial.Write(message)
	
	#await get_tree().create_timer(0.5).timeout
	
	#print("Read: ",serial.Read())
	
	pass # Replace with function body.
