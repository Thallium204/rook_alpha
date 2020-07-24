extends Node2D

onready var Globals = get_tree().get_root().get_node("Game/Globals")
onready var FactoryFloor = Globals.get_node("FactoryFloor")

# Deemed by building connection
var noOfSegments = 0
var connectedEntityNodes = [] # [ node (from) , node (to) ]
var entityNodeIDs = []

# Deemed by conveyor type
var nameID = null
var extractAmount = 0
var conveyorSpeed = 0 # Time taken to roll forward
var conveyorTimer = 0.0
var turnedOn = false

func configureConveyorData(conveyorData):
	nameID = conveyorData[0]
	extractAmount = conveyorData[1]
	conveyorSpeed = conveyorData[2]
	
	# Add all buildings/segments to the reference list
	entityNodeIDs = []
	entityNodeIDs.append( connectedEntityNodes[0] )
	for segID in range(noOfSegments):
		entityNodeIDs.append( get_node("texSegment_"+str(segID)) )
		entityNodeIDs[-1].intStorage[2] = conveyorData[3]
	entityNodeIDs.append( connectedEntityNodes[1] )
	#print(entityNodeIDs)
	
	# Configure all to/fromLists
	for entityPos in range(noOfSegments+1):
		entityNodeIDs[entityPos  ].toList.append(   entityNodeIDs[entityPos+1] )
		entityNodeIDs[entityPos+1].fromList.append( entityNodeIDs[entityPos  ] )
		

func moveConveyor():
	
	#print("\nEntities\n")
	for segmentNodePos in range(2,entityNodeIDs.size()+1):
		#print(entityNodeIDs[-segmentNodePos].name,' - ',entityNodeIDs[-segmentNodePos].toList)
		entityNodeIDs[-segmentNodePos].pushForward()
	
	conveyorTimer = 0.0
	
	# Draw segment UI
	for segmentNodePos in range(1,entityNodeIDs.size()-1):
		#print(entityNodeIDs[-segmentNodePos].name,' - ',entityNodeIDs[-segmentNodePos].toList)
		entityNodeIDs[segmentNodePos].updateUI()


func _process(delta):
	
	if turnedOn == true: # If the conveyor is active
		# Progress Timers
		conveyorTimer += delta
		# If its time to push the conveyor
		if conveyorTimer >= conveyorSpeed: # If its time to push the conveyor
			moveConveyor()
			#print("\nInventories\n")
			#for entity in entityNodeIDs:
			#	print(entity.name)
			#	print(entity.getStorage())
			connectedEntityNodes[0].updateBuildingUI()
			connectedEntityNodes[1].updateBuildingUI()
